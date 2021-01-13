#!/bin/bash
serverName="Rpi-Prod"
backupContent="/var/www"
rm /home/pi/Share/Rpi_www_Backup.tar.gz;
tar czvf /home/pi/Share/Rpi_www_Backup.tar.gz /var/www/;
echo "${serverName} ${backupContent} Backup Done." | mail -s "${serverName} ${backupContent} Backup Done." anlrj@qq.com;
