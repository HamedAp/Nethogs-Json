#!/bin/bash
#By Hamed Ap

if command -v apt-get >/dev/null; then
sudo apt update -y
sudo apt-get install build-essential libncurses5-dev libpcap-dev make zip unzip wget -y
elif command -v yum >/dev/null; then
yum update -y
yum install gcc-c++ libpcap-devel.x86_64 libpcap.x86_64 "ncurses*"
fi
sudo wget -O /root/nethogs.zip https://github.com/HamedAp/Nethogs-Json/archive/refs/heads/main.zip
sudo unzip /root/nethogs.zip
sudo mv -f /root/Nethogs-Json-main /root/nethogs
cd /root/nethogs/
sudo chmod 744 /root/nethogs/determineVersion.sh
sudo make install
hash -r
sudo cp /usr/local/sbin/nethogs /usr/sbin/nethogs -f
sudo rm -fr /root/nethogs /root/nethogs.zip
sudo setcap "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe" /usr/local/sbin/nethogs
