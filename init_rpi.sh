#!/bin/bash

sudo apt-get update \
    && sudo apt-get install -y locate nano wget curl git net-tools iputils-ping gnupg2 pass xrdp \
    && sudo updatedb \
    && mkdir -p Share/project \
	&& cd Share 
    # \
    # && wget https://github.com/yt-dlp/yt-dlp/releases/download/2024.03.10/yt-dlp_linux_armv7l \
    # && mv yt-dlp_linux_armv7l /home/pi/Share/project/ \
    # && chmod +x /home/pi/Share/project/yt-dlp_linux_armv7l;

cat <<EOF >> ~/.bashrc ;


alias ll='ls -al';
alias home='cd /home/pi/Share';
alias cputemp='cat /sys/class/thermal/thermal_zone0/temp';
# alias yt='/home/pi/Share/project/yt-dlp_linux_armv7l'
alias rclone='/home/pi/Share/project/rclone/rclone'
alias yt='/home/pi/Share/project/youtube/youtubeDownload/yt-dlp_linux_aarch64'
alias sandisk='cd /mnt/sandisk'
alias me='/usr/bin/msedit'



echo "Remember these commands";
echo "ln -s target_location soft_link";

cd /home/pi/Share;

EOF

# solve the Raspberry Pi scrambled / distorted screen with xrdp
sudo adduser xrdp ssl-cert && sudo sed -i 's|Option "DRMDevice" "/dev/dri/renderD128"|Option "DRMDevice" ""|' /etc/X11/xrdp/xorg.conf && sudo service xrdp restart

sed -i 's/HISTSIZE=1000/HISTSIZE=10000000/' /home/pi/.bashrc
sed -i 's/HISTFILESIZE=2000/HISTFILESIZE=200000000/' /home/pi/.bashrc

echo "Initialization is complete..."
