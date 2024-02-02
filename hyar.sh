#!/bin/bash

InstallCommands() {
    GREEN="$(tput setaf 2)[OK]$(tput sgr0)"
    YELLOW="$(tput setaf 3)[NOTE]$(tput sgr0)"
    CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
    LOG="install.log"

    printf "%s Welcome to the HyprArch Linux INSTALLER!!!!!!\n" "$(tput setaf 2)"
    sleep 2

    printf "%s No Worries I Wrote This Script That'll Do Everything for You!\n" "$YELLOW"
    sleep 2

    printf "%s Some commands require you to enter your password in order to execute. You only have to give minimal attention to this script.\n" "$YELLOW"
    sleep 3

    # Check if yay is installed
    ISyay=/sbin/yay

    if [ -f "$ISyay" ]; then
        printf "%s - yay was located, moving. No need to reinstall.\n" "$GREEN"
    else
        printf "%s - yay was NOT located\n" "$YELLOW"
        if ! command -v yay &>/dev/null; then
            git clone https://aur.archlinux.org/yay.git
            cd yay || exit
            makepkg -si --noconfirm 2>&1 | tee -a "$LOG"
            cd ..
        fi
        # Update system before proceeding
        printf "%s System Update to avoid issue\n" "$YELLOW"
        yay -Syu --noconfirm 2>&1 | tee -a "$LOG"
    fi

    # Function to print success messages
    print_success() {
        printf "%s%s%s\n" "$GREEN" "$1" "$NC"
    }

    ### Install packages ###
    printf "%s Lets install the packages!\n" "$CAT"
    echo

    1_pkgs="gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite wlroots slurp xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus"
    2_pkgs="grimblast-git sddm-git hyprpicker-git waybar-hyprland-git hyprland wl-clipboard wf-recorder wofi wlogout swaylock-effects dunst qt5base qt6base swaybg kitty rofi-lbonn-wayland hyprshotgun neofetch btop htop gtk2 gtk3 gtk4 layer-shell-gtk cliphist imv layer-shell-qt"
    3_pkgs="ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font otf-sora ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd adobe-source-code-pro-fonts upower aylurs-gtk-shell eww-wayland"
    4_pkgs="dracula-icons-git ranger kora-icon-theme-git ranger_devicons-git gruvbox-dark-icons-gtk gruvbox-plus-icon-theme-git papirus-icon-theme aalib ascii font-manager fontconfig gjs glib2 libpulse pam typescript libnotify  libsoup3 power-profiles-daemon"
    5_pkgs="nwg-look-bin qt5ct btop htop jq gvfs ffmpegthumbs swww notepadqq automake autoconf autoconf-archive mpv brightnessctl playerctl pamixer noise-suppression-for-voice polkit-kde-agent ffmpeg neovim viewnior pavucontrol thunar ffmpegthumbnailer tumbler thunar-archive-plugin xdg-user-dirs xdg-user-dirs-gtk"
    6_pkgs="kvantum-theme-catppuccin-git nordic-theme starship goober python-requests zenity yad multilib-devel tk base-devel networkmanager network-manager-applet nano nm-connection-editor dconf libexif mpv vlc nano-syntax-highlighting libdecor libva"
    6_pkgs="go python nodejs archiso archinstall arch-install-scripts geany geany-plugins alacritty archlinux-contrib jq gobject-introspection firefox reflector reflector-simple python-pyaml python-pipx python-pip python-pyperclip python-click python-rich npm wlsunset mpv vlc nano-syntax-highlighting qt5ct qt6ct"

    if ! yay -S --noconfirm "$1_pkgs" "$2_pkgs" "$3_pkgs" "$4_pkgs" "$5_pkgs" "$6_pkgs" "$7_pkgs" 2>&1 | tee -a "$LOG"; then
        sleep 2
        echo -ne '>>>>>>>                   [40%]\r'
        sleep 2
        echo -ne '>>>>>>>>>>>>>>            [60%]\r'
        sleep 2
        echo -ne '>>>>>>>>>>>>>>>>>>>>>>>   [80%]\r'
        sleep 2
        echo -ne '>>>>>>>>>>>>>>>>>>>>>>>>>>[100%]\r'
        echo -ne '\n'
    fi

    xdg-user-dirs-update
    echo
    print_success " All necessary packages installed successfully."


# Function to create directory if it doesn't exist
create_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

# Create directories if they don't exist
create_directory "$HOME/.config/hypr/scripts"
create_directory "$HOME/.config/rofi/scripts"
create_directory "$HOME/.config/wofi/scripts"
create_directory "$HOME/.config/waybar/scripts"

# Install required packages
yay -S --noconfirm gifsicle lz4 wlr-randr swww

# Sleep and show spinner
sleep 47 &
PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]; do
    printf "\b${sp:i++%${#sp}:1}"
done

# Initialize and set path for swww
swww init && swww img home/Wallpapers

# Install Waypaper-engine
yay -S --noconfirm waypaper-engine

# Spinner function
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

# Doing important work
printf 'Doing important work '
spinner &

sleep 43  # Sleeping for 43 seconds is important work

kill "$!" # Kill the spinner
printf '\n'

# Run waypaper-engine
waypaper-engine
waypaper-engine r --script="$HOME/.config/hypr/scripts"

# Add to hyprland.conf
echo "exec-once=waypaper-engine daemon" >> "$HOME/.config/hypr/hyprland.conf"



    ### Copy Config Files ###
            printf " Copying config files...\n"
        cp dunst ~/.config/ 2>&1 | tee -a "$LOG"
        cp wofi ~/.config/ 2>&1 | tee -a "$LOG"
        cp kitty ~/.config/ 2>&1 | tee -a "$LOG"
        cp pipewire ~/.config/ 2>&1 | tee -a "$LOG"
        cp rofi ~/.config/ 2>&1 | tee -a "$LOG"
        cp swaylock ~/.config/ 2>&1 | tee -a "$LOG"
        cp waybar ~/.config/ 2>&1 | tee -a "$LOG"
        cp wlogout ~/.config/ 2>&1 | tee -a "$LOG"
        cp btop ~/.config/ 2>&1 | tee -a "$LOG"
        cp htop ~/.config/ 2>&1 | tee -a "$LOG"
        cp wlogout ~/.config/ 2>&1 | tee -a "$LOG"
        cp eww ~/.config/ 2>&1 | tee -a "$LOG"
        cp ags ~/.config/ 2>&1 | tee -a "$LOG"
        cp geany ~/.config/ 2>&1 | tee -a "$LOG"
        cp ranger ~/.config/ 2>&1 | tee -a "$LOG"
        cp alacritty ~/.config/ 2>&1 | tee -a "$LOG"
        cp swww ~/.config/ 2>&1 | tee -a "$LOG"
        cp swwaypaper-engineww ~/.config/ 2>&1 | tee -a "$LOG"







        # Set some files as executable
        chmod +x ~/.config/hypr/xdg-portal-hyprland
        chmod +x ~/.config/waybar/scripts/waybar-wttr.py
    fi

    ### Add Fonts for Waybar ###
    mkdir -p "$HOME/Downloads/nerdfonts/"
    cd "$HOME/Downloads/" || exit
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/CascadiaCode.zip
    unzip '*.zip' -d "$HOME/Downloads/nerdfonts/"
    rm -rf *.zip
    sudo cp "$HOME/Downloads/nerdfonts/" /usr/share/fonts/

    fc-cache -rv

    ### Enable SDDM Autologin ###
    echo -e "Enabling SDDM service...\n"
    sudo systemctl enable sddm
    sleep 3

    # BLUETOOTH
    blue_pkgs="bluez bluez-utils blueman"
    if ! yay -S --noconfirm "$blue_pkgs" 2>&1 | tee -a "$LOG"; then
        printf " Activating Bluetooth Services...\n"
        sudo systemctl enable --now bluetooth.service
        sleep 2
    fi
  

systemctl disable systemd-resolved

sleep 2
systemctl disable systemd-networkd
sleep 2
systemctl enable NetworkManager
sleep 4
systemctl start NetworkManager
sleep 4

    ### Script is done ###
    printf "\n${GREEN} Installation Completed.\n"

}

InstallCommands
