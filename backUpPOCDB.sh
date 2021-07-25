#!/bin/sh

host=$(hostname);
time=`date +'%Y%m%d_%H%M%S'`;
outputFile="/home/pi/Share/POC_DB_${time}.dump"
onedriveFolder="onedrive:My Files/Backup/Rpi/POC_DB/";
onedriveFile="${onedriveFolder}_POC_DB_${time}.dump"
mailMessage="${host}: POC DB Backup is completed and uploaded to OneDrive: ${onedriveFile}"

rm -f /home/pi/Share/POC_DB.dump*;
sudo mysqldump -uroot -ppassword1! poc > /home/pi/Share/POC_DB.dump;
zip -P xxxxxx "${outputFile}" /home/pi/Share/POC_DB.dump;
/home/pi/Share/rclone/rclone copy "${outputFile}" "${onedriveFolder}" --log-file=/home/pi/Share/mylogfile.txt --log-level INFO;
echo "${mailMessage}" | mail -s "${mailMessage}" anlrj@qq.com;

#rm /home/pi/Share/POC_DB.dump;
#rm /home/pi/Share/POC_DB.dump.zip ;


