#!/bin/bash

mkdir ~/Share;
cd ~/Share;
apt-get update && apt-get install -y gcc apache2-dev apache2 libxml2-dev mariadb-server locate nano wget curl git net-tools iputils-ping sudo gnupg2 default-libmysqlclient-dev;
service mysql restart;

mysql -u root;
use mysql;
update user set plugin='' where User='root';
flush privileges;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('xxxxxxxx');
create user boroger identified by 'xxxxxxxx';
grant all on *.* to boroger@'%' with grant option;
create database poc;
exit;

wget https://www.php.net/distributions/php-5.4.39.tar.gz
tar zxvf php-5.4.39.tar.gz
cd php-5.4.39

./configure --with-regex=system --with-mysql --with-apxs2=/usr/bin/apxs2

make && make install

a2dismod mpm_event
a2enmod mpm_prefork

a2enmod cgi



#add the cgi folder in the apache2.conf
cat <<EOF >>/etc/apache2/apache2.conf
<Directory /var/www/mapserver/cgi-bin>
        Options +ExecCGI
        AddHandler cgi-script .cgi .py
</Directory>
EOF

#To enable the apache2 support for PHP
echo <<EOF >>/etc/apache2/apache2.conf
AddType application/x-httpd-php .php
EOF


#change the root folder for apache at 
sed -i 's/DocumentRoot/#DocumentRoot/g' /etc/apache2/sites-enabled/000-default.conf
sed -i '/#DocumentRoot/ a \\t DocumentRoot /var/www' /etc/apache2/sites-enabled/000-default.conf

cd /var/www

wget xxx 

tar zxvf 

cat << 'EOF' >> /etc/ld.so.conf.d/mapserver_ld.conf
/var/www/mapserver/mapserver_lib
EOF

ldconfig

service apache2 restart

