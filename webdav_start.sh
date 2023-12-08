#!/bin/bash 
log_start_sh_log="/home/pi/Share/log_start_sh_log.log"

[ -f "${log_start_sh_log}" ] && "${log_start_sh_log}";

aliyundrive-webdav --port=8080 --debug --auto-index --auth-user=admin --auth-password=admin  --refresh-token='xxxx' >> "${log_start_sh_log}"&

sleep 2;

fusermount -uz /home/pi/Share/webdav_mount/aliyun >> "${log_start_sh_log}";

sleep 2;

/home/pi/Share/project/rclone/rclone mount aliyun:/ /home/pi/Share/webdav_mount/aliyun --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty >> "${log_start_sh_log}" &

sleep 2; 

fusermount -uz /home/pi/Share/webdav_mount/onedrive >> "${log_start_sh_log}";

sleep 2; # need to sleep 10 seconds for the previous command to finish executing, otherwise, below command will fail 

/home/pi/Share/project/rclone/rclone mount onedrive:/ /home/pi/Share/webdav_mount/onedrive --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty >> "${log_start_sh_log}" &  

sleep 2; 
