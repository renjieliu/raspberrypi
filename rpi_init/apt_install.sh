#!/bin/bash 

sudo apt update 
sudo apt-get install -y locate nano wget curl git net-tools iputils-ping gnupg2 pass xrdp zstd msmtp msmtp-mta mailutils
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER


