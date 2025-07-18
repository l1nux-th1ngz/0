#!/bin/bash

echo "This script will add the best Bookworm repositories"

# Remove current sources.list
sudo rm -f /etc/apt/sources.list

# Create a new sources.list with Debian Bookworm repositories
cat <<EOL | sudo tee /etc/apt/sources.list > /dev/null
deb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *
EOL

# Update package lists
sudo apt-get update

echo "Initial repositories added and package list updated."
echo "-------------------------------------------------------------------------------"

# Install necessary packages
sudo apt-get -y install firmware-linux-nonfree fasttrack-archive-keyring devscripts

# Append fasttrack repositories to sources.list
sudo bash -c 'cat <<EOL >> /etc/apt/sources.list
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-fasttrack main contrib
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-backports-staging main contrib
EOL'

# Update package lists again
sudo apt-get update
sudo apt-get -y dist-upgrade

echo "Fasttrack repositories added and package list updated."
echo "-------------------------------------------------------------------------------"

# Prompt user whether to install backports kernel
read -p "Would you like to install the backports kernel? (Y/n): " response
if [[ "$response" =~ ^[Yy]$ || -z "$response" ]]; then
    # Install necessary tools
    sudo apt-get install -y lsb-release curl apt-transport-https

    # Install backports kernel and headers
    sudo apt-get -t bookworm-backports install -y linux-image-amd64 linux-headers-amd64 firmware-linux

    # Update again to ensure latest packages
    echo "Running apt update again..."
    sudo apt-get update
fi

echo "Script completed. Consider rebooting to use the new kernel."
