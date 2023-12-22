# add below line to crontab to start the webdav service on reboot

@reboot sudo -u pi /path/to/webdav_start.sh >> /path/to/pi_crontab_log.log 2>&1


