#!/bin/bash

# Clean disk before installation
sudo dd if=/dev/zero of=/dev/nvme0n1 bs=512 count=1

# Create new partition table (GPT)
parted --script /dev/nvme0n1 mklabel gpt

# Partition the disk
parted --script /dev/nvme0n1 \
    mkpart primary fat32 1MiB 1.5GiB \
    set 1 esp on \
    mkpart primary ext4 1.5GiB 51.5GiB \
    mkpart primary ext4 51.5GiB 100% \
    quit

# Format the partitions
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

# Mount the partitions
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
mkdir -p /mnt/home
mount /dev/nvme0n1p3 /mnt/home

# Sync mirrors and install necessary packages
ping -c 3 archlinux.org >/dev/null && \
  sudo pacman -Syy reflector --noconfirm && \
  sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -S --noconfirm git curl wget
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
source "$HOME/.cargo/env"
sudo pacman -S --noconfirm base-devel multilib-devel networkmanager network-manager-applet nm-connection-editor dconf libexif libnotify libxml nodejs python gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender jdk-openjdk pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus gvfs udisks2 udiskie automake autoconf autoconf-archive go sddm plymouth polkit-kde-agent xdg-user-dirs xdg-user-dirs-gtk gradle ffmpeg aalib glibc glib2 fcitx5-gtk gtk2 gtk3 gtk4 blues blues-utils blueman kvantum colord-gtk colord-gtk-commom colord-gtk4 fcitx5-gtk granite granite7 gtk-engines gtk-engines-murrine gtk-layer-shell xdg-desktop-portal xdg-desktop-portal-gtk geany geany-plugins xdg-desktop-portal-wlr xdg-desktop-portal-hyprland xdg-utils libcanberra grim imv kanshi layer-shell-qt libdecor libva mako nano npm font-manager fontconfig qt5base qt6base qt5wayland qt6wayland slurp swaybg swayidle wayland wayland-utils wlsunset wlroots wofi cliphist mpv vlc nano-syntax-highlighting

#
xdg-users-update

# Copy configuration files
cp /wlogout /mnt/home/{your_username}/.config/
cp /wofi /mnt/home/{your_username}/.config/
cp /slurp /mnt/home/{your_username}/.config/
cp /grim /mnt/home/{your_username}/.config/
cp /wlsunset /mnt/home/{your_username}/.config/
cp /mako /mnt/home/{your_username}/.config/
cp /swaybg /mnt/home/{your_username}/.config/
cp /mmpv /mnt/home/{your_username}/.config/
cp /vlc /mnt/home/{your_username}/.config/

# Install Yay
git clone https://aur.archlinux.org/yay-bin.git /mnt/home/{your_username}/yay-bin
chown -R {your_username}:{your_username} /mnt/home/{your_username}/yay-bin
cd /mnt/home/{your_username}/yay-bin
sudo -u {your_username} makepkg -si
yay -Y --gendb yay -Syu --devel yay -Y --devel --save
yay -S --noconfirm hyprland firefox kitty ranger

# Enable services
arch-chroot /mnt /bin/bash -c "systemctl enable sddm"
arch-chroot /mnt /bin/bash -c "systemctl enable --now bluetooth.service"
arch-chroot /mnt /bin/bash -c "systemctl disable systemd-resolved"
arch-chroot /mnt /bin/bash -c "systemctl disable systemd-networkd"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
arch-chroot /mnt /bin/bash -c "systemctl start NetworkManager"

# Post-installation
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel -s /bin/bash {your_username}"
arch-chroot /mnt /bin/bash -c "passwd {your_username}"
arch-chroot /mnt /bin/bash -c "EDITOR=nano visudo"

# Clean up and reboot
rm /mnt/home/{your_username}/install_arch.sh
umount -R /mnt
reboot
