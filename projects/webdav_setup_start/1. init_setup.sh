############ 64 bit aarch64 ############


sudo apt-get update \
    && sudo apt-get install -y locate nano wget curl git net-tools iputils-ping gnupg2 pass xrdp \
    && sudo updatedb \
    && mkdir Share \
	&& cd Share \
	&& mkdir -p /home/pi/Share/webdav_mount/aliyun \
	&& mkdir -p /home/pi/Share/webdav_mount/onedrive \
    && wget https://downloads.rclone.org/v1.65.0/rclone-v1.65.0-linux-arm64.zip \
    && unzip rclone-v1.65.0-linux-arm64.zip \
    && mv rclone-v1.65.0-linux-arm64 rclone\
    && cd rclone \
    && wget https://github.com/messense/aliyundrive-webdav/releases/download/v2.3.3/aliyundrive-webdav_2.3.3_arm64.deb \
    && sudo dpkg -i aliyundrive-webdav_2.3.3_arm64.deb \
    && aliyundrive-webdav qr login


############################################################



############ 32 bit ARMV6, 7, 8l ########################

sudo apt-get update \
    && sudo apt-get install -y locate nano wget curl git net-tools iputils-ping gnupg2 pass xrdp \
    && sudo updatedb \
    && mkdir Share \
	&& cd Share \
	&& mkdir -p /home/pi/Share/webdav_mount/aliyun \
	&& mkdir -p /home/pi/Share/webdav_mount/onedrive \
    && wget https://downloads.rclone.org/v1.65.0/rclone-v1.65.0-linux-arm-v7.zip \
    && unzip rclone-v1.65.0-linux-arm-v7.zip \
    && mv rclone-v1.65.0-linux-arm-v7 rclone \
    && cd rclone \
    && wget https://github.com/messense/aliyundrive-webdav/releases/download/v2.3.3/aliyundrive-webdav_2.3.3_armhf.deb \
    && sudo dpkg -i aliyundrive-webdav_2.3.3_armhf.deb \
    && aliyundrive-webdav qr login

############################################################






# uncomment allow in below file
sudo nano /etc/fuse.conf 

# config onedrive and aliyun with below command
/home/pi/Share/rclone/rclone config


# run below all to test if it all works
aliyundrive-webdav --port=8080 --debug --auto-index --auth-user=admin --auth-password=admin  --refresh-token='TOKEN_FROM_ALIYUN' > /dev/null &
/home/pi/Share/rclone/rclone mount aliyun:/ /home/pi/Share/webdav_mount/aliyun --allow-other --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty > /dev/null &
/home/pi/Share/rclone/rclone mount onedrive:/ /home/pi/Share/webdav_mount/onedrive --allow-other --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty > /dev/null &




