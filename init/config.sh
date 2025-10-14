#!/bin/bash 

# To config pi account
# The script need to be run under pi account, sudo -u pi 


set -e


sed -i 's/HISTSIZE=1000/HISTSIZE=10000000/' /home/pi/.bashrc
sed -i 's/HISTFILESIZE=2000/HISTFILESIZE=200000000/' /home/pi/.bashrc

# Adding below entries to the ~/.bashrc file

cat <<EOF >>/home/pi/.bashrc 


###########  Below are my config ##################

alias sms_when_job_done='curl --header '\''Access-Token: o.btNDvVgXmCk8M76KSiAOnwmPkkO5y4j2'\'' --header '\''Content-Type: application/json'\'' --data-binary '\''{"data":{"addresses":["+19142886360"],"message":"The job on Rpi is done","target_device_iden":"ujDs08MxSUesjBhUfh9GV2"}}'\'' --request POST https://api.pushbullet.com/v2/texts; echo ';
alias cputemp='cat /sys/class/thermal/thermal_zone0/temp'
alias sandisk='cd /mnt/sandisk'


echo "Remember these commands";
echo "ln -s target_location soft_link";


cd /home/pi/Share;


EOF


