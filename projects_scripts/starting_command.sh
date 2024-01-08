#!/bin/bash

#these are the commands/process automatically started on reboot

nohup bash /home/pi/Share/generate_cpu_stat.sh &
sleep 2

mount -t ntfs-3g /dev/sda1 /mnt/sandisk
sleep 2



