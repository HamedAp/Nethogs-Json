#!/bin/bash
#By Hamed Ap
apt update -y
apt upgrade -y
apt-get install build-essential libncurses5-dev libpcap-dev make -y

sudo wget -O /root/nethogs.zip https://github.com/HamedAp/Nethogs-Json/archive/refs/heads/main.zip

unzip /root/nethogs.zip

mv -f /root/Nethogs-Json-main /root/nethogs


cd /root/nethogs/
chmod 744 /root/nethogs/determineVersion.sh

sudo make install
hash -r


