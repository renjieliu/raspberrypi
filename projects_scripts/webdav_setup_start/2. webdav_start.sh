#!/bin/bash 
log_start_sh_log="/home/pi/Share/log_start_sh_log.log"

[ -f "${log_start_sh_log}" ] && rm "${log_start_sh_log}";

aliyundrive-webdav --port=8080 --debug --auto-index --auth-user=admin --auth-password=admin  --refresh-token='xxxxx' >> "${log_start_sh_log}"&

sleep 2;

fusermount -uz /home/pi/Share/webdav_mount/aliyun >> "${log_start_sh_log}";

sleep 2;

#the user_allow_other needs to be enabled in /etc/fuse.conf first (just remove the # before #user_allow_other in /etc/fuse.conf)
/home/pi/Share/project/rclone/rclone mount aliyun:/ /home/pi/Share/webdav_mount/aliyun --allow-other --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty >> "${log_start_sh_log}" &

sleep 2; 

fusermount -uz /home/pi/Share/webdav_mount/onedrive >> "${log_start_sh_log}";

sleep 2; 

/home/pi/Share/project/rclone/rclone mount onedrive:/ /home/pi/Share/webdav_mount/onedrive --allow-other --default-permissions --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty >> "${log_start_sh_log}" &  

sleep 2; 



