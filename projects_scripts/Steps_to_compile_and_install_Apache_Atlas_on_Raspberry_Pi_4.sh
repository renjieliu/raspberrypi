use the revised pom.xml

export MAVEN_OPTS="-Xms2g -Xmx2g";

mvn clean -DskipTests install -X && sms_when_job_done ;	

mvn clean -DskipTests package -Pdist;

cd /home/pi/Share/dp/

cp -r /home/pi/Share/dp/atlas-build/distro/target/apache-atlas-2.0.0-bin/* ./atlas

/home/pi/Share/dp/solr/bin/solr start;
sleep 1;
ssh pi@dataNode1 /home/pi/Share/dp/solr/bin/solr start;
sleep 1;
ssh pi@dataNode2 /home/pi/Share/dp/solr/bin/solr start;
sleep 1;

---export the hbase conf dir at /home/pi/Share/dp/atlas/conf

cat >>/home/pi/Share/dp/atlas/conf/atlas-env.sh << 'EOF'

# RL 2020-11-15: specify the configure file for the Hbase
export HBASE_CONF_DIR=/home/pi/Share/dp/hbase/conf

EOF

;
 
/home/pi/Share/dp/hbase/bin/hbase-daemon.sh start master
ssh pi@dataNode1 "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf; /home/pi/Share/dp/hbase/bin/hbase-daemon.sh start regionserver"
ssh pi@dataNode2 "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf; /home/pi/Share/dp/hbase/bin/hbase-daemon.sh start regionserver"

/home/pi/Share/dp/solr/bin/solr create -c vertex_index -s 2 -rf 2 -force 
/home/pi/Share/dp/solr/bin/solr create -c edge_index -s 2 -rf 2 -force 
/home/pi/Share/dp/solr/bin/solr create -c fulltext_index -s 2 -rf 2 -force


/home/pi/Share/dp/atlas/bin/atlas_start.py

/home/pi/Share/dp/atlas/bin/atlas_stop.py
