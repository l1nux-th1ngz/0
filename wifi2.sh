#!/bin/bash

# List all the wireless devices
iwctl device list

# Replace 'wlan0' with your device name from the above command
iwctl station wlan0 scan

# List all the networks
iwctl station wlan0 get-networks

# Connect to the network
# Replace 'WIFI_NAME' and 'WIFI_PASSWORD' with your Wi-Fi name and password
iwctl station wlan0 connect Banshee  --passphrase BlueGhost11!!

# Auto exit and returns to home screen autorun arch.sh
# Run the script
./arch.sh
