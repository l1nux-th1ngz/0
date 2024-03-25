

make this a shell scrpt


#!/bin/bash

# 1st Display
sudo apt install -y xorg xserver-xorg xbacklight xbindkeys xvkbd xinput
sudo apt install -y gdebi synaptic udisks2 udiskie ja lxappearance
sudo apt install -y xserver-xorg-input-all npm golang

sudo apt update 

# Sleeping I will resume shorty

read -t 20 -p 'HAHA This is a 20 second wait  ' 
status=$?   
if [ $status -eq 142 ]
then
    echo "your wait is over"
fi


# 2nd Build Uils
sudo apt-get install -y \
    xcb \
    cmake \
    gcc \
    libgtk-3-dev \
    ninja-build \
    libgtkmm-3.0-dev \
    libxcb-randr0 \
    libxcb-randr0-dev \
    libxcb-util-dev \
    libxcb-util0-dev \
    libxcb-util1 \
    libxcb-ewmh-dev \
    libxcb-xinerama0 \
    libxcb-xinerama0-dev \
    libxcb-icccm4-dev \
    libxcb-keysyms1-dev \
    libxcb-cursor-dev \
    libxcb-shape0-dev \
    build-essential

	sudo apt update
	
read -t 300 -p ' This is a 30 second wait  ' 
status=$?   
if [ $status -eq 142 ]
then
    echo "your wait is over"
fi

echo "### Cloning Hypr"
git clone https://github.com/vaxerski/Hypr

sleep 5

cd Hypr

sleep 5

make clear && make release

sleep 5

echo "### Copying files ###..."
sudo cp ./build/Hypr /usr/bin

sleep 2
sudo cp ./example/hypr.desktop /usr/share/xsessions
sleep 2


# Install additional packages
sudo apt-get install -y thunar ranger xdg-user-dirs-gtk pic0m
xdg-user-dirs-gtk-update
sudo apt-get install -y kitty alacritty terminator rofi polybar
sudo apt-get install -y gdebi synaptic lxappearence geany notepadqq

sleep 4
sudo apt-get install -y wireplumber

# Enable wireplumber audio service
sleep 5
sudo -u $username systemctl --user enable wireplumber.service Install each package listed
sudo apt install -y \
    acl \
    aria2 \
    autoconf \
    automake \
    binutils \
    bison \
    brotli \
    bzip2 \
    coreutils \
    curl \
    dbus \
    dnsutils \
    dpkg \
    dpkg-dev \
    fakeroot \
    file \
    findutils \
    flex \
    fonts-noto-color-emoji \
    ftp \
    g++ \
    gcc \
	gdebi \
    gnupg2 \
    haveged \
    imagemagick \
    iproute2 \
    iputils-ping \
    jq \
    lib32z1 \
    libc++-dev \
    libc++abi-dev \
    libc6-dev \
    libcurl4 \
    libgbm-dev \
    libgconf-2-4 \
    libgsl-dev \
    libgtk-3-0 \
    libmagic-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libsecret-1-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libunwind8 \
    libxkbfile-dev \
    libxss1 \
    libyaml-dev \
    locales \
    lz4 \
    m4 \
    make \
    mediainfo \
    mercurial \
    net-tools \
    netcat \
    openssh-client \
    p7zip-full \
    p7zip-rar \
    parallel \
    pass \
    patchelf \
    pigz \
    pkg-config \
    pollinate \
    python-is-python3 \
    rpm \
    rsync \
    shellcheck \
    sphinxsearch \
    sqlite3 \
    ssh \
    sshpass \
    subversion \
    sudo \
    swig \
	synaptic \
    tar \
    telnet \
    texinfo \
    time \
    tk \
    tzdata \
    unzip \
    upx \
    wget \
    xorriso \
    xvfb \
    xz-utils \
    zip \
    zsync

    #up 
    sudo apt aupdate

# Optional: Clean up packages that are no longer needed
sudo apt autoremove -y

# u again
sudo apt update

# Optional: Clean up cached package archives
sudo apt clean -y

# Done
echo "Installation complete."

sudo apt update
read -t 40 -p 'HAHA This 40 second wait is for you sky  ' 
status=$?   
if [ $status -eq 142 ]
then
    echo "your wait is over"
fi


# Clone and configure  
echo "### Cloning ###"
git clone https://github.com/l1nux-th1ngz/00.git
sleep 2
cd 00
sleep 2
mv hypr ~/.config
mv polybar ~/.config
mv sxhkd ~/.config

# go home
cd ~

# Install SDDM
sudo apt install --no-install-recommends -y sddm

# Define arrays for package installation and display managers
sddm=("sddm") 


# Function to check and install package
pkg_install() {
    if sudo dpkg -s "$1" &> /dev/null; then
        echo -e "$1 is already installed"
    else
        echo -e "Installing $1"
        sudo apt install --no-install-recommends -y "$1"
    fi
}

# Install SDDM 
printf "\n%s --> Installing SDDM.... \n"
for pkg in "${sddm[@]}"; do
    pkg_install "$pkg"
done


# Enable SDDM service
printf "\n Activating the SDDM service... \n"
sudo systemctl enable sddm
sleep 3

# Make sure it starts Hypr
systemctl set-default graphical.target
sleep 5



echo -e "SDDM is installed successfully..."
sudo apt-get update && sudo apt-get upgrade -y


systemctl start sddm

read -t 10 -p 'restarting in 10 secs  ' 
status=$?   
if [ $status -eq 142 ]
then
    echo "your wait is over"
fi


 sudo reboot -y

