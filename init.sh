#!/bin/bash

sudo apt-get update;
sudo apt-get install -y locate git wget nano ;

sudo echo 'interface wlan0' >> /etc/dhcpcd.conf;
sudo echo 'static ip_address=192.168.1.208/24'  >> /etc/dhcpcd.conf;
sudo echo '#static ip6_address=fd51:42f8:caae:d92e::ff/64'  >> /etc/dhcpcd.conf;
sudo echo 'static routers=192.168.1.1'  >> /etc/dhcpcd.conf;
sudo echo 'static domain_name_servers=192.168.1.1 8.8.8.8 fd51:42f8:caae:d92e::1'  >> /etc/dhcpcd.conf;

echo alias python='python3.7' >> ~/.bashrc;

mkdir ~/Share;
sudo chmod 777 -R ~/Share;
sudo mkdir /mnt/sandisk;
sudo chmod 777 -R /mnt/sandisk;
sudo curl -sSL https://get.docker.com | sh;
sudo usermod -aG docker pi;
sudo raspi-config;
sudo updatedb;
