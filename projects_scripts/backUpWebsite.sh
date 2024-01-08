#!/bin/bash

host=$(hostname);
time=`date +'%Y%m%d_%H%M%S'`;
backupContent="/var/www";
outputFile="/home/pi/Share/Rpi_www_Backup_${time}.tar.gz";
onedriveFolder="onedrive:My Files/Backup/Rpi/var_www/";
onedriveFile="${onedriveFolder}_Rpi_www_Backup_${time}.tar.gz"
mailMessage="${host}: ${backupContent} Backup Done and uploaded to OneDrive: ${onedriveFile}"

rm -f /home/pi/Share/Rpi_www_Backup*
tar czvf "${outputFile}" /var/www/
/home/pi/Share/rclone/rclone copy "${outputFile}" "${onedriveFolder}" --log-file=/home/pi/Share/mylogfile.txt --log-level INFO;
echo "${mailMessage}" | mail -s "${mailMessage}" anlrj@qq.com;
