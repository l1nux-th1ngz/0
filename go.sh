#!/bin/bash

# Exit on errors
set -euo pipefail

# Install Go
sudo -i <<'ENDOFSUDO'
# Remove existing Go installation if any
rm -rf /usr/local/go

# Download the specified Go version
wget -cq https://go.dev/dl/go1.24.4.linux-amd64.tar.gz

# Extract to /usr/local
tar -C /usr/local -xzf go1.24.4.linux-amd64.tar.gz
ENDOFSUDO

# Create a workspace directory
mkdir -p ~/Go

# Add /usr/local/go/bin to system-wide PATH
if ! grep -q "/usr/local/go/bin" /etc/profile; then
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
    echo "Added /usr/local/go/bin to system-wide PATH in /etc/profile"
fi

# Create a file in /etc/profile.d/
sudo tee /etc/profile.d/go.sh <<EOF
export PATH=\$PATH:/usr/local/go/bin
EOF

# To apply the change immediately for the current session:
# source /etc/profile

echo "DONE"
