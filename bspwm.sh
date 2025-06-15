#!/bin/bash

# Update package list
sudo apt-get update

# Install X11 packages
sudo apt-get -y install autoconf autoconf-archive automake \
    xorg xorg-dev xinit x11-xserver-utils xsetroot pkg-config x11-utils \
    xbacklight xbindkeys libx11-dev libxft-dev libxinerama-dev libxrandr-dev \
    xvkbd xinput xdotool wmctrl gvfs-backends dialog libnotify-dev libnotify-bin \
    libxtst-dev libpango1.0-dev libxpm-dev libncurses5-dev libxcursor-dev \
    mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev xrdp

# Build tools and dependencies
sudo apt-get -y install make cmake ninja-build autorandr autotools-dev \
    libxrandr-dev libxinerama-dev mesa-common-dev libgl1-mesa-dev \
    libglu1-mesa-dev rxvt-unicode xcb libxcb-util0-dev libxcb-ewmh-dev \
    libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev \
    libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev build-essential git vim

# Additional utilities
sudo apt-get -y install mtools smbclient cifs-utils ripgrep fd-find
sudo apt-get -y install bluez blueman maim scrot slop pkexec terminator
sudo apt-get -y install bluefish bluefish-data bluefish-plugins
sudo apt-get -y install gdebi synaptic

# Install bspwm and thangs 
sudo apt-get -y install bspwm sxhkd xclip dunst kitty  
network-manager network-manager-gnome pavucontrol pamixer pulsemixer 
nemo xdg-user-dirs-gtk libnotify-bin libnotify-dev feh pipewire-audio
avahi-daemon acpi acpid gnome-power-manager power-profiles-daemon
suckless-tools acpi-support acpi-support-base avahi-autoipd xautomation
sudo apt-get -y install tmux links htop ncdu ranger gparted alacritty

# Set up user directories
xdg-user-dirs-update
sleep 2
# Set locale for user directories
echo "en_US.UTF-8" > ~/.config/user-dirs.locale

# Set up bspwm and sxhkd configuration directories
mkdir -p ~/.config/bspwm ~/.config/sxhkd

# Copy default configuration files 
if [ ! -f ~/.config/bspwm/bspwmrc ]; then
    cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
    chmod +x ~/.config/bspwm/bspwmrc
fi

if [ ! -f ~/.config/sxhkd/sxhkdrc ]; then
    cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
    chmod +x ~/.config/sxhkd/sxhkdrc
fi


# tab completetion
cat contrib/bash_completion >> ~/.bashrc
cat contrib/zsh_completion >> ~/.zshrc

# Fonts & spell checking
sudo apt-get -y install fonts-dejavu fonts-dejavu-extra fonts-droid-fallback
sudo apt-get -y install fonts-freefont-ttf fonts-liberation fonts-noto-mono 
sudo apt-get -y install fonts-opensymbol ttf-bitstream-vera ttf-mscorefonts-installer

# Create ~/.xsessionrc
cat <<EOF > ~/.xsessionrc
# Add session startup commands here
EOF

chmod +x xsessionrc

# Create ~/.xinitrc
if ! grep -q "exec bspwm" ~/.xinitrc 2>/dev/null; then
    echo "exec bspwm" >> ~/.xinitrc
fi

chmod +x .xinitrc

# Install the login manager
sudo apt-get -y install lightdm-gtk-greeter lightdm-gtk-greeter-settings lightdm-settings

# Enable the LightDM GTK
sudo systemctl enable lightdm-gtk-greeter

   # Set bspwm as the default session manager
    sudo update-alternatives --set x-session-manager "$(which bspwm)"
else
    echo "bspwm not found in PATH."
fi

# Enable
sudo systemctl enable power-profiles-daemon
sudo systemctl enable avahi-daemon 
sudo systemctl enable acpid 
sudo systemctl enable gnome-power-manager.service
sudo systemctl enable bluetooth

echo "Installation completed."
