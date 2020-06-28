##### 1. Download and install prerequisites

sudo apt-get install -y openjdk-8-jdk

sudo rm /etc/ssl/certs/java/cacerts 

sudo update-ca-certificates -f

wget https://artifacts.elastic.co/downloads/kibana/kibana-7.8.0-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.8.0-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.8.0.tar.gz


tar zxvf kibana-7.8.0-linux-x86_64.tar.gz
tar zxvf elasticsearch-7.8.0-linux-x86_64.tar.gz
tar zxvf logstash-7.8.0.tar.gz


##### 2. change the Kibana configuration

sudo nano kibana-7.8.0-linux-x86_64/conf/kibana.yml  --> change the server.host to "0.0.0.0"


##### 3. start elasticsearch and Kibana
./elasticsearch-7.8.0/bin/elasticsearch
./kibana-7.8.0/bin/kibana


##### 4. copy the mysql jdbc to following location, it can be found here - https://drive.google.com/file/d/1_Yy6iXrwdoD5evELguqClFcHQ2S9c7eR/view

nano ./logstash-7.8.0/import_mysql.conf

## logstash configuration file to load data from mysql

input {
  jdbc {
    jdbc_connection_string => "jdbc:mysql://192.168.1.206:3306/poc?serverTimezone=UTC"
    # The user we wish to execute our statement as
    jdbc_user => "boroger"
    jdbc_password => "xxxxxxxxxxxxxxxxxxxxxx"
    # The path to our downloaded jdbc driver
    jdbc_driver_library => "/home/liurenjie/Share/elk/jdbc/mysql-connector-java-8.0.20.jar"
    jdbc_driver_class => "com.mysql.jdbc.Driver"
    #query
    statement => "SELECT * FROM cpu_temp_memory limit 100"
    }
  }
output {
  stdout { codec => json_lines }
  elasticsearch {
  "hosts" => "localhost:9200"
  "index" => "cpu_temp"
  "document_type" => "data"
  }
}

##### 5. load the data to elasticsearch
./logstash-7.8.0/bin/logstash -f ./logstash-7.8.0/import_mysql.conf


##### 6. check if the load is OK
curl -XPOST 'http://localhost:9200/cpu_temp/_search?pretty=true' -d '{}' -H 'Content-Type: application/json'


##### 7. configure the index pattern in Kibana to enable the cpu_temp index just imported.
