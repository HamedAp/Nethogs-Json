#!/bin/bash
#By Hamed Ap

# Install dependencies
if command -v apt-get >/dev/null; then
    sudo apt update -y
    sudo apt-get install build-essential libncurses5-dev libpcap-dev make zip unzip wget -y
elif command -v yum >/dev/null; then
    yum update -y
    yum install gcc-c++ libpcap-devel.x86_64 libpcap.x86_64 "ncurses*" -y
fi

# Download and build
sudo wget -O /root/nethogs.zip https://github.com/HamedAp/Nethogs-Json/archive/refs/heads/main.zip
sudo unzip /root/nethogs.zip
sudo mv -f /root/Nethogs-Json-main /root/nethogs
cd /root/nethogs/

sudo chmod 744 /root/nethogs/determineVersion.sh
sudo make install
hash -r

# === MODIFIED PART: Smart nethogs path detection ===
NETHOGS_PATH=""

if [ -f "/usr/local/sbin/nethogs" ]; then
    NETHOGS_PATH="/usr/local/sbin/nethogs"
elif [ -f "/usr/sbin/nethogs" ]; then
    NETHOGS_PATH="/usr/sbin/nethogs"
else
    echo "❌ Error: nethogs binary not found in /usr/local/sbin or /usr/sbin"
    exit 1
fi

echo "✅ nethogs found at: $NETHOGS_PATH"

# Copy to /usr/sbin if installed in /usr/local/sbin
if [ "$NETHOGS_PATH" = "/usr/local/sbin/nethogs" ]; then
    sudo cp -f /usr/local/sbin/nethogs /usr/sbin/nethogs
    echo "📋 Copied nethogs to /usr/sbin/"
fi

# Clean up
sudo rm -fr /root/nethogs /root/nethogs.zip

# Set capabilities on the correct binary
sudo setcap "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe" "$NETHOGS_PATH"

echo "✅ Installation completed successfully!"
