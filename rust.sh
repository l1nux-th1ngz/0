#!/bin/bash

# Install Rust using rustup with minimal profile and nightly toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain nightly

# Add Cargo bin to PATH for the current session
export PATH="$HOME/.cargo/bin:$PATH"

# Source the shell configuration files to apply changes
# Note: You should only source the relevant config file based on the user's shell
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi

# Update Rust toolchains
rustup update

# Enable completions
# Bash completion
mkdir -p ~/.local/share/bash-completion/completions
rustup completions bash > ~/.local/share/bash-completion/completions/rustup

# Zsh completion
mkdir -p ~/.zfunc
rustup completions zsh > ~/.zfunc/_rustup

# Add the following line to your ~/.zshrc before compinit:
echo "fpath+=~/.zfunc" >> ~/.zshrc

# Final message
echo "Rust installation and completions setup complete."
echo "Please restart your shell or source your configuration files to apply changes."
