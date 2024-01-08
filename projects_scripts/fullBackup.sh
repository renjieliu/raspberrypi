#!/bin/sh

time=`date +'%Y%m%d_%H%M%S'`;
host=$(hostname);
rm -f /mnt/sandisk/$host*img;
dd if=/dev/mmcblk0 of="/mnt/sandisk/${host}_Backup_${time}.img";
#echo "helloworld" > "/mnt/sandisk/${host}_Backup_${time}.img";
onedriveFolder="onedrive:Temp/";
/home/pi/Share/rclone/rclone copy "/mnt/sandisk/${host}_Backup_${time}.img" "${onedriveFolder}" --log-file=/home/pi/Share/mylogfile.txt --log-level INFO;
##/mnt/sandisk/pishrink.sh /mnt/sandisk/$serverName_Backup_$time.img;
# /mnt/sandisk/pishrink.sh "/mnt/sandisk/${host}_Backup_${time}.img";
echo "${host} Backup /mnt/sandisk/${host}_Backup_${time}.img completed! ${host}_Backup_${time}.img uploaded to OneDrive Temp folder." | mail -s "${host} Backup /mnt/sandisk/${host}_Backup_${time}.img completed! ${host}_Backup_${time}.img uploaded to OneDrive Temp folder." anlrj@qq.com;



