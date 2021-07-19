#!/bin/sh
# 20210718_202724: This script is to git pull the github repository, to zip the folder and upload the zip file to Onedrive folder.
cd /home/pi/Share/projects/github/leetcode && git pull && cd - ;
time=`date +'%Y%m%d_%H%M%S'`;
host=$(hostname);
fileName="github_from_${host}_${time}.zip";
onedriveFolder="onedrive:My files/Project/github/";
mailMessage="${fileName} uploaded to OneDrive folder.";

zip -r "${fileName}" /home/pi/Share/projects/github/leetcode /home/pi/Share/projects/github/machine_learning /home/pi/Share/projects/github/personal_projects /home/pi/Share/projects/github/private_projects /home/pi/Share/projects/github/raspberrypi
/home/pi/Share/rclone/rclone copy "${fileName}" "${onedriveFolder}" --log-file=/home/pi/Share/mylogfile.txt --log-level INFO;
rm ${fileName};
echo "${mailMessage}" | mail -s "${mailMessage}" xxxxxx@xx.com;

