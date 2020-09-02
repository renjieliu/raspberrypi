passwd;
sudo passwd;
sudo apt-get update; 
sudo apt-get install -y locate mariadb-server xrdp;
sudo echo 'interface wlan0
static ip_address=192.168.1.xxx/24
#static ip6_address=fd51:42f8:caae:d92e::ff/64
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8 fd51:42f8:caae:d92e::1'  >> a.conf;
echo alias python='python3.7' >> ~/.bashrc;
echo alias pip='pip3' >> ~/.bashrc;
mkdir ~/Share; sudo chmod 777 -R ~/Share;
sudo mkdir /mnt/sandisk; sudo chmod 777 -R /mnt/sandisk;
sudo curl -sSL https://get.docker.com | sh;
sudo updatedb;
sudo raspi-config;
