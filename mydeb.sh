#!/bin/bash

sudo apt install -y xcb cmake gcc libgtk-3-dev ninja-build libgtkmm-3.0-dev libxcb-randr0 libxcb-randr0-dev 
sudo apt install -y libxcb-util-dev libxcb-util0-dev libxcb-util1 libxcb-ewmh-dev libxcb-xinerama0 
sudo apt install -y libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-cursor-dev 
sudo apt install -y libxcb-shape0-dev build-essential x11-xserver-utils xorg libxkbcommon-x11-dev libjpeg-dev 
sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-util-dev
sudo apt install -y libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev 
sudo apt install -y libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev
sudo apt install -y libnotify-bin unzip wmctrl xdotool libnotify-dev intel-microcode psutil libxcb-icccm4-dev 
sudo apt install -y software-properties-common gdebi synaptic psmisc linux-headers-amd64 nvidia-detect
sudo apt install -y libglvnd-dev pkg-config xserver-xorg xbacklight xbindkeys xvkbd xinput acpi_call upower
sudo apt install -y dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends gvfs udisks2 udiskie
sudo apt install -y cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev  
sudo apt install -y libxcb-util0-dev libxcb-xkb-dev pkg-config python3-xcbgen xcb-proto libxcb-xrm-dev 
sudo apt install -y libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev python3-sphinx 
sudo apt install -y libxcb-composite0-dev libuv1-dev libuv1 libjsoncpp-dev libxcb-randr0-dev wmctrl
sudo systemctl enable avahi-daemon
sudo apt install -y pipenv npm zip unzip zlib1g zlib1g-dev xz-utils tar python3-zipp dmraid libnvidia-cfg1-535 libnvidia-common-535 libnvidia-compute-535 gexec lolcat
sudo apt install -y stacer sxhkd xclip ncmpc ncmpc-lyrics ncmpcpp osdlyrics lz4 jq autotools-dev fontconfig font-manager curl wget git
sudo apt install -y automake pkgcong autoconf autoconf-arcive m4 font-manager fontconfig xcb
sleep 2
sudo systemctl enable acpid
sleep 2
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile complete --default-toolchain nightly
# Time to Set path
echo "Rustup installation completed. Press Enter to continue..."
read -r

sudo apt-get install 'gtk2-engines*' --no-install-recommends
sudo apt install -y picom lxappearance
sudo apt install -y jq inotify-tools polkit-gnome xdotool xclip ffmpeg
sudo apt install -y brightnessctl feh maim scrot ncmpcpp  rofi dmenu compton
sudo apt install -y mpv mpd mpc mpdris2 python3-mutagen  playerctl
sudo add-apt-repository contrib non-free
sudo apt install -y ranger thunar thunar-archive-plugin thunar-volman file-roller
sudo apt install -y xdg-user-dirs-gtk
# Update Dirs
xdg-user-dirs-update


sudo apt install -y pulseaudio-module-bluetooth pulseaudio-equalizer pulseaudio-module-jack alsa-utils playerctl pipewire wireplumber pipewire-alsa pipewire-pulse pavucontrol volumeicon-alsa pamixer

# Enable wireplumber
sudo -u $username systemctl --user enable wireplumber.service
sleep 2
sudo apt install -y bluez blueman
# Enable Bluetooth
sudo systemctl enable bluetooth
sleep 2
sudo apt install -y xrdb lxappearance xvkbd
sudo apt install -y materia-gtk-theme papirus-icon-theme
sudo apt install -y fonts-font-awesome
sudo apt install -y fonts-droid-fallback
sudo apt install -y nala feh
sudo apt install -y obs-studio mkvtoolnix-gui
sudo apt install -y terminator rxvt-unicode urxvtd kitty
sudo apt install -y numlockx figlet cpu-x udns-utils whois tree
sudo apt install -y notepadqq geany geany-plugins cherrytree

