#!/bin/bash
# =============================================
# Nethogs-Json Installer - Steps Only
# Author: Hamed Ap
# =============================================

set -e

echo "🚀 Starting Nethogs-Json Installation"

# Step 1
echo "Step 1: Installing dependencies..."
if command -v apt-get >/dev/null 2>&1; then
    sudo apt update -y >/dev/null 2>&1
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        UBUNTU_VERSION=$(echo "$VERSION_ID" | cut -d. -f1)
    fi
    if [[ "$ID" == "ubuntu" && "$UBUNTU_VERSION" == "24" ]]; then
        sudo apt install -y build-essential libncurses-dev libpcap-dev make zip unzip wget >/dev/null 2>&1
    else
        sudo apt install -y build-essential libncurses5-dev libpcap-dev make zip unzip wget >/dev/null 2>&1
    fi
elif command -v yum >/dev/null 2>&1; then
    sudo yum update -y >/dev/null 2>&1
    sudo yum install -y gcc-c++ libpcap-devel libpcap ncurses-devel make zip unzip wget >/dev/null 2>&1
else
    echo "Error: Unsupported system"
    exit 1
fi

# Step 2
echo "Step 2: Downloading Nethogs-Json..."
sudo wget -q -O /root/nethogs.zip https://github.com/HamedAp/Nethogs-Json/archive/refs/heads/main.zip

# Step 3
echo "Step 3: Extracting files..."
sudo unzip -q /root/nethogs.zip -d /root/
sudo mv -f /root/Nethogs-Json-main /root/nethogs

# Step 4
echo "Step 4: Building and installing..."
cd /root/nethogs/
sudo chmod 744 determineVersion.sh
sudo make install >/dev/null 2>&1
hash -r

# Step 5
echo "Step 5: Copying binary and cleaning up..."
sudo cp -f /usr/local/sbin/nethogs /usr/sbin/nethogs 2>/dev/null || true
sudo rm -rf /root/nethogs /root/nethogs.zip

# Step 6
echo "Step 6: Setting capabilities..."
sudo setcap "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+ep" /usr/local/sbin/nethogs

echo "✅ Installation completed successfully!"
