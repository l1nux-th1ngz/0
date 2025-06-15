#!/bin/bash

# Install necessary packages
sudo apt-get -y install bash-completion zsh zsh-common zsh-antigen \
  zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel9k zsh-dev \
  git-lfs git-all curl wget

# Download and install the zsh completions package
wget -O zsh-completions_0.34.0-1+2.8_amd64.deb "https://github.com/l1nux-th1ngz/bg/raw/main/zsh-completions_0.34.0-1+2.8_amd64.deb"
if [ $? -eq 0 ]; then
    sudo dpkg -i zsh-completions_0.34.0-1+2.8_amd64.deb
    sudo apt-get -f install -y
else
    echo "Download failed. Exiting." >&2
    exit 1
fi

# Set environment variables for config directory
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Create the zsh configuration directory and file
mkdir -p "$ZDOTDIR"
ZSHRC="$ZDOTDIR/.zshrc"

# Write zsh configuration
cat << 'EOF' > "$ZSHRC"
# Enable colors
autoload -U colors && colors

# Set prompt
PS1="%{$fg[green]%}[%{$reset_color%} %{$fg[blue]%}%1~%{$reset_color%} %{$fg[green]%}]%{$reset_color%}$ "

# Enable options
setopt autocd
setopt interactive_comments
setopt INC_APPEND_HISTORY

# History configuration
HISTSIZE=268435456
SAVEHIST="$HISTSIZE"
HISTFILE="$ZDOTDIR/.zsh_history"

# Key bindings
bindkey '^R' history-incremental-search-backward
bindkey -v
export KEYTIMEOUT=1

# Vi keybindings in visual mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# ZLE functions
zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}
zle -N zle-line-init

zle-keymap-select () {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q';;
    main|viins) echo -ne '\e[5 q';;
  esac
}
zle -N zle-keymap-select

preexec() { echo -ne '\e[5 q'; }

# Bindings for fzf and other commands
bindkey -s '^a' 'bc -lq\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char
bindkey -e
bindkey -M main '^e' edit-command-line
autoload edit-command-line; zle -N edit-command-line

# Source plugins
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
# Replace with the correct path if different
source /usr/local/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Aliases
alias p="ping google.com"
alias ll="/usr/local/bin/lsd --long --group-dirs=first"
alias lla="/usr/local/bin/lsd --long --all --group-dirs=first"
alias llt="/usr/local/bin/lsd --tree --all"
alias shell="vim $ZDOTDIR/.zshrc"
alias profile="vim $HOME/.zprofile"
alias rm="trash"

# Function to kill processes
pk() {
  pgrep -i "$1" | sudo xargs kill -9
}
EOF

# Prompt user whether to set zsh as default shell
read -p "Do you wish to set zsh as your default shell? (y/n): " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    chsh -s "$(which zsh)"
    echo "Zsh has been set as your default shell. Please restart your terminal."
else
    echo "Installation complete. Zsh is not set as your default shell."
fi
