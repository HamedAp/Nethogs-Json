#!/bin/bash
#By Hamed Ap

if command -v apt-get >/dev/null; then
apt update -y
apt upgrade -y
apt-get install build-essential libncurses5-dev libpcap-dev make zip unzip wget -y
elif command -v yum >/dev/null; then
yum update -y
yum install gcc-c++ libpcap-devel.x86_64 libpcap.x86_64 "ncurses*"
fi
sudo wget -O /root/nethogs.zip https://github.com/HamedAp/Nethogs-Json/archive/refs/heads/main.zip
unzip /root/nethogs.zip
mv -f /root/Nethogs-Json-main /root/nethogs
cd /root/nethogs/
chmod 744 /root/nethogs/determineVersion.sh
sudo make install
hash -r
