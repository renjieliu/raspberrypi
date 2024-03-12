#!/bin/bash

sudo apt-get update \
    && sudo apt-get install -y locate nano wget curl git net-tools iputils-ping gnupg2 pass xrdp \
    && sudo updatedb \
    && mkdir Share \
	&& cd Share;

cat <<EOF >> ~/.bashrc ;


alias ll='ls -al';
alias home='cd /home/pi/Share';
alias cputemp='cat /sys/class/thermal/thermal_zone0/temp';


echo "Remember these commands";
echo "ln -s target_location soft_link";

cd /home/pi/Share;

EOF

sed -i 's/HISTSIZE=1000/HISTSIZE=10000000/' /home/pi/.bashrc
sed -i 's/HISTFILESIZE=2000/HISTFILESIZE=200000000/' /home/pi/.bashrc

echo "Initialization is complete..."
