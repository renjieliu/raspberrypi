#!/bin/sh
while [ 1 ];
time=`date +'%Y-%m-%d_%H:%M:%S'`;
temp=`/opt/vc/bin/vcgencmd measure_temp | sed -e "s/'C//g" | sed "s/temp=//g"`;
date=`date +'%Y-%m-%d'`;

do
  #mysql -uroot -ppassword1! -D POC -e "insert into cpu_temp(time, temp, date) values('${time}', '${temp}','${date}');"
  echo "${time}" " temp=${temp}'C" >>/home/pi/Share/CPUTemp.txt;  
  #echo "/var/www/ms.php time=`date +'%Y-%m-%d_%H:%M:%S'` temp=`/opt/vc/bin/vcgencmd measure_temp | sed -e "s/'C//g" | sed "s/temp=//g"` date=`date +'%Y-%m-%d'`" | xargs php ; #insert cpu_temp info into the cpu_temp table hosted on Microsoft Azure database.
 sleep 10;
done
