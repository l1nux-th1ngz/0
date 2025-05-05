#!/bin/bash

# Define the download location
DOWNLOAD_DIR=~/local/bin
FILE_NAME=yt-dlp
FILE_PATH=$DOWNLOAD_DIR/$FILE_NAME

# Create the download directory if it doesn't exist
mkdir -p $DOWNLOAD_DIR

# Function to download yt-dlp
download_yt_dlp() {
    if command -v curl &> /dev/null; then
        echo "Using curl to download yt-dlp..."
        curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $FILE_PATH
    elif command -v wget &> /dev/null; then
        echo "Using wget to download yt-dlp..."
        wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O $FILE_PATH
    elif command -v aria2c &> /dev/null; then
        echo "Using aria2c to download yt-dlp..."
        aria2c https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp --dir $DOWNLOAD_DIR -o $FILE_NAME
    else
        echo "Error: No suitable download tool found (curl, wget, aria2c)."
        exit 1
    fi

    # Make the file executable
    sudo chmod a+rx $FILE_PATH
    echo "yt-dlp installed successfully at $FILE_PATH"
}

# Check if yt-dlp is already installed and update if necessary
if [ -f $FILE_PATH ]; then
    echo "yt-dlp is already installed. Updating..."
    $FILE_PATH -U
else
    download_yt_dlp
fi
