#!/bin/bash
#By Hamed Ap

sudo wget -O /root/nethogs.zip https://github.com/HamedAp/Nethogs-Json/archive/refs/heads/main.zip

unzip /root/nethogs.zip

mv /root/Nethogs-Json-main /root/nethogs


cd /root/nethogs/

make install

