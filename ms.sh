#!/bin/bash

# Clone the repository
git clone https://github.com/vaxerski/Hypr

# Wait for the cloning process to complete
wait

# Change directory to Hypr
cd Hypr

# Make clean and release
make clean && make release

# Copy the built executable to /usr/bin
sudo cp ./build/Hypr /usr/bin

# Copy the desktop file to /usr/share/xsessions
sudo cp ./example/hypr.desktop /usr/share/xsessions

# Scan for missing dependencies on Debian/Linux Mint
missing_deps=$(sudo apt-get install -s $(grep -v '#' ./dependencies.txt))
if [ -n "$missing_deps" ]; then
    echo "The following dependencies are missing:"
    echo "$missing_deps"
    # Install missing dependencies
    sudo apt-get install -y $(grep -v '#' ./dependencies.txt | awk '{print $1}')
fi

echo "Installation completed."
