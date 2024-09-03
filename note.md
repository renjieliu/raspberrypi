### Initiation

#### One liner initiation for Rpi ###

```
sudo apt-get update \
    && sudo apt-get install -y locate nano wget curl git net-tools iputils-ping gnupg2 pass xrdp \
    && sudo updatedb \
    && mkdir Share \
	&& cd Share;
```

or 

```bash 
wget https://raw.githubusercontent.com/renjieliu/raspberrypi/master/init_rpi.sh && chmod +x ./init_rpi.sh && ./init_rpi.sh
```

#### To add Apache2, Mariadb and PHP stack

```
sudo apt-get update && sudo apt-get install -y mariadb-server php php-gd php-mysql apache2

sudo a2enmod cgi 
```

---

####  Docker related

##### New machine initialization before installing docker
```
sudo apt-get update && sudo apt-get install gnupg2 pass -y; #for docker login password management
```
##### Install docker

```
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
```
##### Install docker compose

```
sudo apt-get install docker-compose -y
```

##### save docker image to a .tar file, for migration
```
docker save ebdf4c99a > ~/Share/raspbian_20180622_1625_zookeeper.tar
```

##### load the export docker image
```
docker load raspbian_20180622_1625_zookeeper.tar
```

#### docker import, this is to import a filesystem as an image, it may or may not be an image itself


#### Initialize a docker ubuntu

``` 
apt-get update && apt-get install -y nano locate wget curl git ssh net-tools iputils-ping sudo \
			   && mkdir Share && cd Share && updatedb;
useradd pi 
passwd pi

```

---

 
#### Setup static ip

```
sudo echo 'interface wlan0
#change the static ip in below line
static ip_address=192.168.1.215/24
#static ip6_address=fd51:42f8:caae:d92e::ff/64
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8 fd51:42f8:caae:d92e::1'  >> /etc/dhcpcd.conf;

```

#### for new raspberry pi release, to confiure static ip
```
sudo nmtui
```


-------


#### Change the default ssh port from 22 to 5802

```
sudo nano /etc/ssh/sshd_config
```

##### using sed to change

``` 
sudo sed -i 's/Port 22/Port 5802/g' /etc/ssh/sshd_config

```
 


#### set up the password for anydesk unattended access
```
echo passwordhere | sudo anydesk --set-password
```

---

#### Initialize mariadb
``` 
sudo apt-get install mariadb-server
```

##### change mysql password and create new user
```

sudo mysql -u root;
use mysql;
--update user set plugin='' where User='root';
--SET PASSWORD FOR 'root'@'localhost' = PASSWORD('password');
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
flush privileges;
create user boroger identified by 'password';
grant all on *.* to boroger@'%' with grant option;

```

---


#### Install pi-hole to block all the ads

After install, need to change the DNS on the client (laptops,tablet) to the raspberry pi.

```
sudo curl -sSL https://install.pi-hole.net | bash
```

---

#### Start flask webservice in docke container

 
```
docker container run -ti -p 5000:5000 -e FLASK_APP=app.py --rm -e FLASK_DEBUG=1 -v $PWD:/app --name web1 web1
```
 

---

#### GET CPU TEMPERATURE - cputemp
```
cat /sys/class/thermal/thermal_zone0/temp
```
---


#### Install and setup the mail client to send mail 


```
sudo apt-get install msmtp msmtp-mta mailutils -y
sudo nano /etc/msmtprc
```

##### below information for the /etc/msmtprc ----------------------
1. Log onto gmail for liurenjiemessaxx @gmail.com
2. Get an app password for the new client, from https://myaccount.google.com/apppasswords
3. Remove the space in the password
4. add below information to /etc/msmtprc

```
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log
account        gmail
host           smtp.gmail.com
port           587
from           liurenjiemessage@gmail.com
user           liurenjiemessage@gmail.com
password       xxxxxxxxxxxxx 
account default : gmail
```

5. Test with below code 
```
echo "Hello from ${HOSTNAME} mail test" | mail -s "Hello from ${HOSTNAME} mail test" xx@xxxx.com
```

##### use -A option if need to contain an attachment ###

```
echo "Hello from ${HOSTNAME} mail test" | mail -s "Hello from ${HOSTNAME} mail test" -A test.txt xx@xxxx.com
```

---

#### Fix the task bar 
```
rm -r /home/pi/.config/lxpanel
lxpanelctl restart
```
 
---

#### Increase the swap size 
```
free -m
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
free -m
```


---



#### Install and configure Samba Service

1. Install
```
sudo apt-get install -y samba; 
```

2. find the samba configure file 
```
locate smb.conf;
sudo nano /etc/samba/smb.conf;
```

3.add below lines to the end of the file
```
[Share]
path = /home/pi/Share
browseable = yes
writeable = yes
guest ok = yes

[sandisk]
path = /mnt/sandisk
browseable = yes
writeable = yes
guest ok = yes

[var_www]
path = /var/www
browseable = yes
writeable = yes
guest ok = yes

```

4. Restart the service
```
sudo service smbd restart
```

5. optional: configure password access for samba shared drive 

* 5.1. add the user password to the samba server, set the username and password
```
sudo smbpasswd -a pi
```
* 5.2. find the samba configure file 
```
locate smb.conf;
sudo nano /etc/samba/smb.conf;
```
* 5.3.add below lines to the end of the file
```
[SECURED]
path = /mnt/sandisk
valid users = @pi
browsable = yes
writable = yes
read only = no

[sandisk]
path = /mnt/sandisk
browseable = yes
writeable = yes
guest ok = no 

```

* 5.4. Restart the service
```
sudo service smbd restart

```

---


#### Change Timezone

```
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
date # to check if the change takes effect
```


---



#### Mount exFat 

```
sudo apt-get install exfat-fuse exfat-utils
sudo mount -t exfat /dev/sdb1 /mnt/sandisk/
```

#### Unmount the drive
```
cd ~
sudo umount /mnt/sandisk/
```

---


#### chroot to debian system

```
sudo apt-get install -y debootstrap
mkdir debian_for_chroot
cd debian_for_chroot/
sudo debootstrap --arch armhf buster .
sudo mount -t sysfs /sys ./debian_for_chroot/sys
sudo mount -t proc /proc ./debian_for_chroot/proc
sudo mount --bind /dev ./debian_for_chroot/dev
sudo mount --bind /dev/pts ./debian_for_chroot/dev/pts
sudo mount --bind /dev/shm ./debian_for_chroot/dev/shm
sudo chroot ./debian_for_chroot/ /bin/bash
```

---


#### Docker for Azure SQL Edge, it can be connected from SQL Server Management Studio

```
docker pull mcr.microsoft.com/azure-sql-edge:latest
```

##### sample start command; DO NOT USE DIRECTLY
```
sudo docker run --cap-add SYS_PTRACE -e 'ACCEPT_EULA=1' -e 'MSSQL_SA_PASSWORD=<passwdxxxxxx>' -p 1434:1433 --name mssql -d mcr.microsoft.com/azure-sql-edg
```

##### Making directories for volume

```
mkdir -p /home/pi/Share/azsql/data
mkdir -p /home/pi/Share/azsql/log
mkdir -p /home/pi/Share/azsql/secrets

chmod -R 777 /home/pi/Share/azsql/data
chmod -R 777 /home/pi/Share/azsql/log
chmod -R 777 /home/pi/Share/azsql/secrets
```

```
docker run --restart always -e 'ACCEPT_EULA=Y'\
							-e 'ACCEPT_EULA_ML=Y'\
							-e 'MSSQL_SA_PASSWORD=<passwdxxxxxx>'\
							-p 1434:1433\
							-v /home/pi/Share/azsql/data:/var/opt/mssql/data\
							-v /home/pi/Share/azsql/log:/var/opt/mssql/log\
							-v /home/pi/Share/azsql/secrets:/var/opt/mssql/secrets\
							-d mcr.microsoft.com/azure-sql-edge
```

---


#### Install OpenVPN

```
wget https://git.io/vpn -O openvpn-install.sh && sudo bash openvpn-install.sh
```
---



#### Port Forward on Linux with iptables

##### Check existing rules
```
sudo iptables -t nat -L -n
```

##### Add the rule ###
```
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.8.0.2:2222
```
##### Delete the rule ###

```
sudo iptables -t nat -D PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.8.0.2:2222
```

---



#### Switch to another user and run commands #####

```
su pi -c "echo $USER"
```

-----


##### Add new Linux .so file library folder

1. Check the ld.so.conf file - 
```
sudo cat /etc/ld.so.conf
``` 

It should look like this: <br>

``` 
# include /etc/ld.so.conf.d/*.conf 
```
2. Add the new file to the folder mentioned above

```
sudo nano /etc/ld.so.conf.d/new_Folder_file
```

3. add the path to the new_Folder_file, should only have one line in the file.
/path/to/the/folder


---



##### Python connecting to SQL Server 

```
sudo apt-get install -y python3-pymssql
```

Python code

```
import pymssql

conn = pymssql.connect(server, user, password, db)
cursor = conn.cursor()
cursor.execute("select @@version") #here is the SQL to be executed
conn.commit()

cursor.execute("SELECT @@version")

for row in cursor:
  print(row)

conn.close()
```

---


##### kill a process/command directly 

```
sudo ps -elf | grep -e "the command/process to be found" |  grep -v "grep" | awk {'print $4'} | sudo xargs kill -9
```

---

#### Clear Cache in Linux 
https://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/

##### 1. Clear PageCache only.
```
sync; echo 1 > /proc/sys/vm/drop_caches
```

##### 2. Clear dentries and inodes.

```
sync; echo 2 > /proc/sys/vm/drop_caches
```

##### 3. Clear PageCache, dentries and inodes.
```
sync; echo 3 > /proc/sys/vm/drop_caches 
```
 
---

####  Configure rclone on Raspberry Pi to connect to OneDrive 

1. Download ARM rclone and unzip

```
wget https://downloads.rclone.org/rclone-current-linux-arm.zip
```

2. Log into Raspberry Pi Remotely and open terminal

```
./rclone authorize "onedrive"
``` 
Open browser, get the API access code, Copy everything from the {xxxx}

3. Configure rclone
   
``` 
./rclone config 

```

```
# name: onedrive
# choose the number of onedrive.
# client_id: #press enter without enter anything
# client_secret: # press enter without enter anything
# Choose national cloud region for OneDrive: region> 1 # choose 1 for Microsoft Cloud Global
# Edit advanced config? N
# Use auto config? N 
# Paste the key copied from step 2 
# Your choice > 1: for OneDrive Personal or Business
# Chose drive to use:> 0
# Is that OK:> y
# Yes, this is OK > y
```

##### Test onedrive

1. Below command should list all the files on onedrive, and the setup is successful
```
./rclone ls onedrive:  
```

2. Try copy files: copy file from local to onedrive target/folder_location folder. Displaying progress, and keep all source folders even if they are empty

```
./rclone copy "/path/to/source" onedrive:"path/to/target" -P --create-empty-src-dirs 
```

3. #If necessary, copy the config file to root account
```
sudo mkdir -p /root/.config/rclone/
sudo cp -p /home/pi/.config/rclone/rclone.conf /root/.config/rclone/rclone.conf
```

---


#### Configure Aliyun on Raspberry Pi 

##### Approach 1

1. Logon to Aliyun website, get the refresh token

2. Mount Aliyun as webdav with docker

```
docker run -d --name=aliyunpan-webdav --restart=always -p 23077:23077 -e TZ="America/New_York" -e ALIYUNPAN_REFRESH_TOKEN="xxxxxxxxxxxxxxxxxx" -e ALIYUNPAN_AUTH_USER="admin_user_name_xxxx" -e ALIYUNPAN_AUTH_PASSWORD="admin_password_xxxx" -e ALIYUNPAN_WEBDAV_MODE="rw" -e ALIYUNPAN_PAN_DRIVE="File" -e ALIYUNPAN_PAN_DIR="/" tickstep/aliyunpan-webdav:v0.2.4
```

3. Configure rclone, to connect to the aliyun webdav running in the docker
Note: when entering url, use http://localhost:23077

```
./rclone config
```

4. Test uploading files to aliyun

```
./rclone copy "/path/to/sourcefolder" aliyun_webdav:"/path/to/target" -P --create-empty-src-dirs
```



##### Approach 2

**rclone → webdav server → Aliyun**

```
wget https://github.com/messense/aliyundrive-webdav/releases/download/v2.3.3/aliyundrive-webdav_2.3.3_arm64.deb
```

``` 
dpkg -i aliyundrive-webdav_2.3.3_arm64.deb
```

To get the token, scan with cell phone, login, the token will be generated automatically from raspberry pi

```
aliyundrive-webdav qr login
```

Start webdav server

```
aliyundrive-webdav --port=8080 --debug --auto-index --auth-user=admin --auth-password=admin  --refresh-token='token_here'
```

Get rclone and unzip

```
wget https://downloads.rclone.org/v1.65.0/rclone-v1.65.0-linux-arm64.zip
unzip https://downloads.rclone.org/v1.65.0/rclone-v1.65.0-linux-arm64.zip 
```

Go to the rclone folder 
```
rclone config
```


```
#Choose webdav
#URL: http://0.0.0.0:8080
#Vendor: Other
#username and password as set in the webdav server (admin/admin) as above
#bearer token: press enter directly
#advanced config? N
#Yes, this looks ok
#Quit
```


Test run - copy a folder

```
/home/pi/Share/project/rclone/rclone copy -P /path/to/folder aliyun:/MyFiles/folder/target/ --log-file=/path/to/mylogfile.txt --log-level INFO;
```

Using rlone to mount a folder

```
./rclone mount remote_drive:/ /path/to/local/folder --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty
```


Run below command in case of error - ls: cannot access '/path/to/local/folder': Transport endpoint is not connected

```
fusermount -uz /path/to/local/folder # -z is used to force unmount a fuse mount 
```

---


#### start portainer  

```
docker run -d -p 9222:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

---


#### sqlpad setup


Start sqlpad with docker image

```
docker run -p 3010:3010 -tid liurenjie/sqlpad:v01 /bin/sh -c 'cd /Share/sqlpad/server && node /Share/sqlpad/server/server.js --config /Share/sqlpad/server/config.dev.env'
```

change admin username and password: 
1. run below command 

```
docker run -p 3010:3010 -ti liurenjie/sqlpad:v01
```

1. Find below line and change:
Email address to give admin permissions to.
```
SQLPAD_ADMIN = "pi@pi.com"
SQLPAD_ADMIN_PASSWORD = "xxxxxxxx"

```

```
nano /Share/sqlpad/server/config.dev.env
```

---


#### Raspberry pi check CPU frequency
```
vcgencmd measure_clock arm
```
 
---


#### Install and set up Jupyter Notebook

Install - 

```
pip3 install --upgrade pip && pip3 install jupyterlab
```

Set password

```
jupyter notebook password
```

Start jupyter notebook
```
jupyter-notebook --no-browser --ip=0.0.0.0 --port=8888 &> /dev/null &
```


---

#### Mount the flash drive to /mnt/sandisk folder

```
sudo mount -t exfat $(sudo fdisk -l | grep /dev/sd | grep -v GiB | awk '{print $1}') /mnt/sandisk;
```

---

#### Port forwarding with iptables 

1. Add forwarding rule (192.168.xxx.xxx, server ip,  10.8.xxx.xxx:8080 destination internal ip:port)

```
sudo iptables -t nat -A PREROUTING -d 192.168.xxx.xxx -p tcp --dport 8080 -j DNAT --to-destination 10.8.xxx.xxx:8080
```

2. Delete forwarding rule
* 2.1 show all the rules and find the number to delete

```
sudo iptables -t nat -v -L PREROUTING -n --line-number
```

* 2.2 delete the rule, with the number show above
```
sudo iptables -t nat -D PREROUTING 1
```


---



#### Change default shell for a user 
```
usermod --shell /bin/bash pi
```
 




#### Change default Python version on the system


```
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 2
```
Below command  present a list of installed Python versions. Enter the number corresponding to Python 3.10 to set it as the default.

```
sudo update-alternatives --config python
```


---

#### connect to SQL server from Raspberry Pi 


Download the binary from Microsoft Github repository: https://github.com/microsoft/go-sqlcmd
```
wget https://github.com/microsoft/go-sqlcmd/releases/download/v1.5.0/sqlcmd-v1.5.0-linux-arm64.tar.bz2
```

Extract the tar ball 
``` 
tar xvjf sqlcmd-v1.5.0-linux-arm64.tar.bz2 
```

Connect to the database
```
./sqlcmd -S server:port -U user_name -P pass_word
```


#### Alternative is to use FreeTDS + tsql


```
sudo apt-get install freetds-dev freetds-bin -y
sudo nano /etc/freetds/freetds.conf
```

Add below to the file

```
[serverName_alias]
    host = serverName
    port = 1434
    tds version = 7.3
```


Connect to the SQL Server 

```
tsql -S serverName_alias  -U user_name -P pass_word
```

---


#### Mount an image file as loop device ## 

Identify the structure of the image file, take notes of start_sector, sector_count

```
fdisk -l /path/to/your/image.img
```

Take note of the /dev/loopX

```
sudo losetup -o $((512 * start_sector)) --sizelimit $((512 * sector_count)) -f --show /path/to/your/image.img
```

```sudo mount /dev/loopX /mnt/fat32```

#### Unmount the loop device 

```
sudo umount /mnt/fat32 # to unmount 
sudo losetup -d /dev/loopX # to detach
```

---


#### Steps to make aliyundrive as a network drive on windows
* Tools needed: aliyun_webdav, rclone, samba
* Tested with aliyun_webdav 2.3.3
* rclone: v.1.65
* samba: 4.17 
* Linux: Debian-12, aarch64 

```
- Get aliyundrive webdav from github releaes page and install with 'dkpg -i xxxx.deb'
- Download rclone
- Install the above 2 and samba server
- Modify samba conf to only allow authorized user - check the "Install and configure Samba Service" section above in this file 
- Restart samba service
- Create the target folder to be mounted with rclone: 
rclone mount aliyun:/ /path/to/folder --allow-other --cache-dir /tmp --vfs-cache-mode writes --allow-non-empty
- Get aliyun authentication with command: aliyundrive-webdav qr login 
- Start the aliyundrive webdav service
- Using rclone to mount the remote folder to local, make sure: the user_allow_other needs to be enabled in /etc/fuse.conf first (just remove the # before #user_allow_other in /etc/fuse.conf)
- Put the all scripts into start.sh 
- Modify crontab to execute the start.sh at reboot
- Config on windows to use the share folder from Samba
```

*In case error* 
``` 

ls: cannot access xxxxxxx  Transport endpoint is not connected

Solution:

fusermount -uz /home/pi/Share/project/mnt_aliyun

-z is to force unmount a fuse mount 


```

**Copy from OneDrive to Aliyun**

```
(rclone/rclone copy onedrive:/ aliyun:/path/to_destination -Pv --create-empty-src-dirs --ignore-existing | tee rclone_copy_progress_20231226.txt)
```


---

#### Download all the videos from one youtuber

```
alias yt="/path/to/yt-dlp_linux_aarch64"
URL=@mkbhd && mkdir $URL && cd $URL && yt --print "%(id)s;%(title)s" "https://www.youtube.com/$(echo $URL)/videos" | awk 'BEGIN{ FS=";"} {print "https://www.youtube.com/watch?v="$1;}' >> $(echo $URL).txt && cat $URL.txt | xargs yt
```

---

#### Set up Apache Answer

``` 
MAKE SURE - Need to create a database in mysql: answer or other names for apache answer to use
```

```
mkdir -p ~/Share/project/answer/data && cd ~/Share/project/answer

wget https://github.com/apache/incubator-answer/releases/download/v1.2.0/apache-answer-1.2.0-incubating-linux-arm64.tar.gz

tar zxvf apache-answer-1.2.0-incubating-linux-arm64.tar.gz

sudo INSTALL_PORT=60080 ./answer init  -C ./data/

```

Config answer with ```ip:60080``` from browser

change the port to 9080 or something else 

```
sudo nano data/conf/config.yaml
```

Running Apache Answer

```
sudo ./answer run -C ./data/ 
```

Access the portal in the browser 

```
ip:port_specified
```

---


##### To export MySQL db with mysqldump

```
mysqldump -u username -p dabasebase_name > xxx.SQL
```



##### Convert putty private key to openssh
```
sudo apt-get install putty-tools
puttygen putty.ppk -O private-openssh -o output_ssh_key
```



##### Add below lines to the /etc/apache2/sites-enabled/000-default.conf, right before the </VirtualHost>

for all the url request, website.com/container, it will redirect to the container

```
ProxyPass "/container" "http://localhost:8080" 
ProxyPassReverse "/container" "http://localhost:8080"
```


##### dd over network to another server 

```
dd bs=1k if=/dev/sda | ssh user@serverXXX -p 22 "dd bs=1k of=~/file.img"
```



##### solve the Raspberry Pi scrambled / distorted screen with xrdp
``` 
sudo adduser xrdp ssl-cert && sudo sed -i 's|Option "DRMDevice" "/dev/dri/renderD128"|Option "DRMDevice" ""|' /etc/X11/xrdp/xorg.conf && sudo service xrdp restart
```



##### List all the Google photos

1. rclone config
2. choose google photos in the option list 
3. config like other drives
4. use below command to list google photos

```
./rclone ls google_photos:/media/all  | sed 's/       -1 //g' > list_google_photos.txt # "       -1 " is the at the beginning of each line
# rclone ls google_photos:/media/all  | awk '{print $2}' > list_google_photos.txt
```


_Below command is to list all the google photos with different byYear byMonth and all_

```
rclone ls remote_name_google_photos:/ 
```



##### Download youtube video with audio only 
```bash
yt-dlp -x --audio-format mp3 https://www.youtube.com/watch?v=xxxxxxxxxxx
```




