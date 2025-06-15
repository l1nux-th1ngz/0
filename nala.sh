#!/bin/bash

# Install Nala package manager
if sudo apt-get -y install nala; then
    echo "Nala installed successfully."
else
    echo "Failed to install Nala. Exiting."
    exit 1
fi

echo "Preparing to run Use Nala"

# Check if usenala.sh exists and is a file
if [[ -f "usenala.sh" ]]; then
    chmod +x usenala.sh
    ./usenala.sh
else
    echo "usenala.sh not found. Please ensure it exists in the current directory."
    exit 1
fi
