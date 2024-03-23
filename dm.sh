#!/bin/bash

sudo apt install -y lightdm lightdm-gtk-greeter-settings
sudo apt install -y lightdm-settings
sudo apt install -y slick-greeter
sudo systemctl enable lightdm
systemctl set-default graphical.target
sudo systemctl enable lightdm
