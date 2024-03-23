#!/bin/bash

# Automatic installation of Rust with default settings

# Download and execute Rustup installer
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --profile complete --default-toolchain nightly

# Set path and source cargo environment variables
source $HOME/.cargo/env


