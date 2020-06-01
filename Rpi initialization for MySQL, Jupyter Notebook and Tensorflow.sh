#############################################################################################
# Rpi initialization for MySQL, Jupyter Notebook and Tensorflow
#############################################################################################

mkdir Share;
mkdir Share/jupyter;
sudo apt-get update && sudo apt-get install locate gnupg2 pass -y;
sudo apt-get update && sudo apt-get install gnupg2 pass -y; #for docker login password management


curl -sSL https://get.docker.com | sh ;
sudo usermod -aG docker pi ;
sudo apt-get install docker-compose -y;

sudo apt-get install mariadb-server-10.3 -y;

cd /home/pi/Share/jupyter/;
sudo pip3 install jupyter;
wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v2.2.0/tensorflow-2.2.0-cp37-none-linux_armv7l.whl;
sudo apt-get install python3-pandas libatlas-base-dev ;
sudo pip3 install scipy xlrd seaborn scikit-learn;
sudo pip3 install tensorflow-2.2.0-cp37-none-linux_armv7l.whl;


sudo raspi-config;
passwd;
sudo passwd;
nano ~/.bashrc;

#add below lines to the end of the file
alias python='python3.7';
cd /home/pi/Share;


#echo 'Rpi0_lime_AP -- 192.168.10.1'
# echo 'Jupyter Notebook'
# echo 'Tensorflow 2.1'
echo 'MariaDB 10.3'
echo 'Docker'


echo '---------Notes---------'
echo '---------Notes---------'
echo '---------Notes---------'
echo 'run "jupyter-notebook --no-browser --ip=0.0.0.0 --port=8888 &> /dev/null &" to start Jupyter Notebook'
echo 'run "jupyter notebook password" to set up password'
echo 'current pwd: p!'


source ~/.bashrc ;
sudo updatedb;
sudo docker run hello-world;
jupyter notebook password;
jupyter-notebook --no-browser --ip=0.0.0.0 --port=8888 &> /dev/null &;


sudo mysql;
use mysql;
update user set plugin='' where User='root';
flush privileges;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('xxxxxxxxx');
create user boroger identified by 'xxxxxxxxx';
grant all on *.* to root@'%' with grant option;
grant all on *.* to boroger@'%' with grant option;
quit;
