#!/bin/bash

# Update package list
sudo apt-get update

# Install necessary packages
sudo apt-get -y install bspwm sxhkd rofi xclip dunst kitty polybar 
network-manager network-manager-gnome pavucontrol pamixer pulsemixer 
nemo xdg-user-dirs-gtk libnotify-bin libnotify-dev feh pipewire-audio
avahi-daemon acpi acpid gnome-power-manager power-profiles-daemon
suckluss-tools acpi-support acpi-support-base

# Set up bspwm and sxhkd configuration directories
mkdir -p ~/.config/bspwm ~/.config/sxhkd

# Copy default configuration files if they don't exist
if [ ! -f ~/.config/bspwm/bspwmrc ]; then
    cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
    chmod +x ~/.config/bspwm/bspwmrc
fi

if [ ! -f ~/.config/sxhkd/sxhkdrc ]; then
    cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
    chmod +x ~/.config/sxhkd/sxhkdrc
fi

# Create or update ~/.xinitrc to start bspwm
if ! grep -q "exec bspwm" ~/.xinitrc 2>/dev/null; then
    echo "exec bspwm" >> ~/.xinitrc
fi
