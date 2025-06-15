#!/bin/bash

# Install
sudo apt-get -y install lolcat

# Add to .bashrc
if ! grep -q "lolcat" ~/.bashrc; then
    echo "Adding lolcat to .bashrc"
    echo "PROMPT_COMMAND='echo -n' && PS1='$(echo \"\$(history 1)\" | lolcat) '" >> ~/.bashrc
fi

# Add to .zshrc
if ! grep -q "lolcat" ~/.zshrc; then
    echo "Adding lolcat to .zshrc"
    echo "preexec() { echo \"\$(history 1)\" | lolcat; }" >> ~/.zshrc
fi

# Source the config files
source ~/.bashrc
source ~/.zshrc

echo "Install and setup complete"
