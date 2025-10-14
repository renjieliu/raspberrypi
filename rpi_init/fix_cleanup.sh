#!/bin/bash 

sudo updatedb

sudo -u pi mkdir -p /home/pi/Share/project 


# solve the Raspberry Pi scrambled / distorted screen with xrdp
sudo adduser xrdp ssl-cert
sudo sed -i 's|Option "DRMDevice" "/dev/dri/renderD128"|Option "DRMDevice" ""|' /etc/X11/xrdp/xorg.conf 
sudo service xrdp restart




