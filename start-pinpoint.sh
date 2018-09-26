#!/bin/bash

echo "" 
echo "==> 删除容器pinpoint-collector..." 
docker rm -f pinpoint-collector &> /dev/null

echo "完成" 
echo "==> 创建容器pinpoint-collector..." 

docker run -itd \
--name pinpoint-collector \
--hostname pinpoint-collector \
--net=hadoop --ip 172.28.0.9 -p 9994:9994 -p 9995:9995/udp  -p 9996:9996/udp \
-v $PWD/conf/pinpoint-collector-config/hbase.properties:/opt/apache-tomcat-8.5.34/webapps/ROOT/WEB-INF/classes/hbase.properties \
-v $PWD/conf/pinpoint-collector-config/pinpoint-collector.properties:/opt/apache-tomcat-8.5.34/webapps/ROOT/WEB-INF/classes/pinpoint-collector.properties \
-v $PWD/conf/pinpoint-collector-config/server.xml:/opt/apache-tomcat-8.5.34/conf/server.xml \
-v $PWD/conf/hosts:/etc/hosts \
sampx/pinpoint-collector-1.8.0

sleep 5
echo "完成" 
echo "==> 重新创建容器pinpoint-web..." 
docker rm -f pinpoint-web &> /dev/null

docker run -d \
--name pinpoint-web \
--hostname pinpoint-web \
--net=hadoop --ip 172.28.0.10 -p 28080:28080 \
-v $PWD/conf/pinpoint-web-config/hbase.properties:/opt/apache-tomcat-8.5.34/webapps/ROOT/WEB-INF/classes/hbase.properties \
-v $PWD/conf/pinpoint-web-config/pinpoint-web.properties:/opt/apache-tomcat-8.5.34/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties \
-v $PWD/conf/pinpoint-web-config/server.xml:/opt/apache-tomcat-8.5.34/conf/server.xml \
-v $PWD/conf/hosts:/etc/hosts \
sampx/pinpoint-web-1.8.0

echo "完成" 
