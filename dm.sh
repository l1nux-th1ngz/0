#!/bin/bash

# Install LightDM and related packages
sudo apt install -y lightdm lightdm-gtk-greeter-settings lightdm-settings slick-greeter

# Enable LightDM service
sudo systemctl enable lightdm

# Set default target to graphical
sudo systemctl set-default graphical.target

# Enable LightDM service to start on boot
sudo systemctl enable lightdm

# Configure LightDM to remember the last logged-in username
echo "[Seat:*]" | sudo tee -a /etc/lightdm/lightdm.conf.d/50-lightdm.conf
echo "greeter-hide-users=false" | sudo tee -a /etc/lightdm/lightdm.conf.d/50-lightdm.conf
echo "greeter-show-manual-login=true" | sudo tee -a /etc/lightdm/lightdm.conf.d/50-lightdm.conf
