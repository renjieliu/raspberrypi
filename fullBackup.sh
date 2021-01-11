#!/bin/bash

time=`date +'%Y%m%d_%H%M%S'`;
serverName="Rpi-LAN";
rm -f /mnt/sandisk/$serverName*img;
dd if=/dev/mmcblk0 of="/mnt/sandisk/${serverName}_Backup_${time}.img";
#/mnt/sandisk/pishrink.sh /mnt/sandisk/$serverName_Backup_$time.img;
/mnt/sandisk/pishrink.sh "/mnt/sandisk/${serverName}_Backup_${time}.img";
echo "${serverName} Backup /mnt/sandisk/${serverName}_Backup_${time}.img completed!" | mail -s "${serverName} Backup /mnt/sandisk/${serverName}_Backup_${time}.img completed!" anlrj@qq.com;

