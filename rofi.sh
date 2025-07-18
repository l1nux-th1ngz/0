#!/bin/bash

# Update package list
sudo apt-get update

# Install rofi
sudo apt-get -y install rofi-dev
sudo apt-get -y install papirus-icon-theme
sudo apt-get -y install rofi-dev

# Create directories
mkdir -p "$HOME/config/rofi/themes"
mkdir -p "$HOME/config/rofi/scripts"

# Create configuration files
touch "$HOME/config/rofi/config.rasi"
touch "$HOME/config/rofi/config0.rasi"

# Write main config.rasi
cat << EOF > "$HOME/config/rofi/config.rasi"
configuration {
    modi: "run,drun,window";
    show-icons: true;
    icon-theme: "Obsidian";
    font: "Noto Sans 11";
    sidebar-mode: true;
    //application-fallback-icon: "/usr/share/icons/ePapirus/symbolic/mimetypes/application-x-executable-symbolic.svg";
    application-fallback-icon: "/usr/share/icons/gnome/48x48/emblems/emblem-system.png";

    display-drun: "drun";
    display-run: "run";
    display-window: "windows";
    display-filebrowser: "browser";

    // display-drun: "";
    // display-run: "";
    // display-window: "";
    // display-filebrowser: "";
}
@theme "rounded-fane.rasi"
EOF

# Write config0.rasi
cat << EOF > "$HOME/config/rofi/config0.rasi"
configuration {
    //modi: "drun,run";
    //modi: "drun,run,window";
    //modi: "drun,run,window,:~/.config/rofi/scripts/exit";

    // display-drun: "Applications";
    // display-run: "Run ...";
    // display-window: "Workspaces";
    // display-filebrowser: "Filebrowser";
    display-drun: "";
    display-filebrowser: "";
    display-run: "";
    display-window: "";
}
EOF
