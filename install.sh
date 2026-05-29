#!/bin/bash
# =============================================
# Nethogs-Json Installer Script
# Author: Hamed Ap
# =============================================

set -e  # Exit on error

echo "🚀 Starting Nethogs-Json installation..."

# ====================== Package Manager Detection ======================
if command -v apt-get >/dev/null 2>&1; then
    echo "📦 Detected Debian/Ubuntu-based system"

    sudo apt update -y

    # Detect Ubuntu version
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        UBUNTU_VERSION=$(echo "$VERSION_ID" | cut -d. -f1)
        echo "📌 Detected distribution: $ID $VERSION_ID"
    else
        UBUNTU_VERSION="unknown"
        echo "⚠️  Could not detect Ubuntu version"
    fi

    # Install dependencies based on Ubuntu version
    if [[ "$ID" == "ubuntu" && "$UBUNTU_VERSION" == "24" ]]; then
        echo "🛠 Installing packages for Ubuntu 24.04..."
        sudo apt install -y build-essential libncurses-dev libpcap-dev make zip unzip wget
    else
        echo "🛠 Installing packages for older Ubuntu/Debian..."
        sudo apt install -y build-essential libncurses5-dev libpcap-dev make zip unzip wget
    fi

elif command -v yum >/dev/null 2>&1; then
    echo "📦 Detected RHEL/CentOS/Fedora-based system"
    sudo yum update -y
    sudo yum install -y gcc-c++ libpcap-devel libpcap ncurses-devel make zip unzip wget

else
    echo "❌ Error: Unsupported package manager. Only apt and yum are supported."
    exit 1
fi

# ====================== Download and Install Nethogs-Json ======================
echo "📥 Downloading Nethogs-Json..."

sudo wget -q --show-progress -O /root/nethogs.zip \
    https://github.com/HamedAp/Nethogs-Json/archive/refs/heads/main.zip

echo "📂 Extracting files..."
sudo unzip -q /root/nethogs.zip -d /root/
sudo mv -f /root/Nethogs-Json-main /root/nethogs

cd /root/nethogs/

echo "🔧 Building and installing Nethogs..."
sudo chmod 744 determineVersion.sh
sudo make install

# Refresh hash table
hash -r

# Copy to standard location
sudo cp -f /usr/local/sbin/nethogs /usr/sbin/nethogs 2>/dev/null || true

# Clean up
echo "🧹 Cleaning up temporary files..."
sudo rm -rf /root/nethogs /root/nethogs.zip

# Set capabilities for non-root usage
echo "🔐 Setting network capabilities..."
sudo setcap "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+ep" /usr/local/sbin/nethogs

echo "✅ Installation completed successfully!"
echo "💡 You can now run: sudo nethogs"
