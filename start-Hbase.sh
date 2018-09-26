#!/bin/bash
echo "" 
echo "==> 创建Hadoop数据目录，注意节点数量..." 
mkdir -p \
data/hadoop-data/master/tmp data/hadoop-data/master/name data/hadoop-data/master/data \
data/hadoop-data/slave1/tmp data/hadoop-data/slave1/name data/hadoop-data/slave1/data \
data/hadoop-data/slave2/tmp data/hadoop-data/slave2/name data/hadoop-data/slave2/data \
data/hadoop-data/slave3/tmp data/hadoop-data/slave3/name data/hadoop-data/slave3/data \
data/zk-data/zookeeper1

echo "完成" 
echo "==> 重新创建容器网络..." 
docker network -f rm hadoop &> /dev/null
docker network create --subnet=172.28.0.0/16 hadoop &> /dev/null

echo "完成" 
echo "==> 重新创建hadoop-master..." 
docker rm -f hadoop-master &> /dev/null

docker run -itd \
--name hadoop-master \
--hostname hadoop-master \
--net=hadoop \
--ip 172.28.0.2 -p 50070:50070 -p 8088:8088 \
--privileged \
-v $PWD/conf/hadoop-config:/opt/hadoop-2.7.6/etc/hadoop \
-v $PWD/data/hadoop-data/master/tmp:/opt/hadoop-2.7.6/tmp \
-v $PWD/data/hadoop-data/master/data:/opt/hadoop-2.7.6/hdfs/data \
-v $PWD/data/hadoop-data/master/name:/opt/hadoop-2.7.6/hdfs/name \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hadoop-2.7.6 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 重新创建hadoop-slave1..." 
docker rm -f hadoop-slave1 &> /dev/null

docker run -itd \
--name hadoop-slave1 \
--hostname hadoop-slave1 \
--net=hadoop \
--ip 172.28.0.3 \
--privileged \
-v $PWD/conf/hadoop-config:/opt/hadoop-2.7.6/etc/hadoop \
-v $PWD/data/hadoop-data/slave1/tmp:/opt/hadoop-2.7.6/tmp \
-v $PWD/data/hadoop-data/slave1/data:/opt/hadoop-2.7.6/hdfs/data \
-v $PWD/data/hadoop-data/slave1/name:/opt/hadoop-2.7.6/hdfs/name \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hadoop-2.7.6 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 重新创建hadoop-slave2..." 

docker rm -f hadoop-slave2 &> /dev/null

docker run -itd \
--name hadoop-slave2 \
--hostname hadoop-slave2 \
--net=hadoop \
--ip 172.28.0.4 \
--privileged \
-v $PWD/conf/hadoop-config:/opt/hadoop-2.7.6/etc/hadoop \
-v $PWD/data/hadoop-data/slave2/tmp:/opt/hadoop-2.7.6/tmp \
-v $PWD/data/hadoop-data/slave2/data:/opt/hadoop-2.7.6/hdfs/data \
-v $PWD/data/hadoop-data/slave2/name:/opt/hadoop-2.7.6/hdfs/name \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hadoop-2.7.6 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 重新创建hadoop-slave3..." 
docker rm -f hadoop-slave3 &> /dev/null

docker run -itd \
--name hadoop-slave3 \
--hostname hadoop-slave3 \
--net=hadoop \
--ip 172.28.0.12 \
--privileged \
-v $PWD/conf/hadoop-config:/opt/hadoop-2.7.6/etc/hadoop \
-v $PWD/data/hadoop-data/slave3/tmp:/opt/hadoop-2.7.6/tmp \
-v $PWD/data/hadoop-data/slave3/data:/opt/hadoop-2.7.6/hdfs/data \
-v $PWD/data/hadoop-data/slave3/name:/opt/hadoop-2.7.6/hdfs/name \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hadoop-2.7.6 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 启动Hadoop..." 
docker exec -it hadoop-master bash -c '$HADOOP_HOME/sbin/start-dfs.sh && $HADOOP_HOME/sbin/start-yarn.sh'

echo "完成，等待20秒..." 
sleep 20

echo "==> 重新创建容器zookeeper1（单机仅作演示用）..." 
docker rm -f zookeeper1 &> /dev/null

docker run -itd \
--name zookeeper1 \
--hostname zookeeper1 \
--net=hadoop --ip 172.28.0.5 \
--privileged \
-v $PWD/conf/zookeeper-config:/opt/zookeeper-3.4.10/conf \
-v $PWD/data/zk-data/zookeeper1:/opt/zookeeper-3.4.10/data \
sampx/zookeeper-3.4.10 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 启动zookeeper1..." 

docker exec -it zookeeper1 bash -c '$ZK_HOME/bin/zkServer.sh start'

echo "完成，等待10秒..." 

sleep 10

echo "完成" 
echo "==> 重新创建容器hbase-master..." 

docker rm -f hbase-master &> /dev/null

docker run -itd \
--name hbase-master \
--hostname hbase-master \
--net=hadoop \
--ip 172.28.0.6 -p 16010:16010 \
--privileged \
-v $PWD/conf/hbase-config:/opt/hbase-1.2.7/conf \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hbase-1.2.7 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 重新创建容器hbase-slave1..." 

docker rm -f hbase-slave1 &> /dev/null

docker run -itd \
--name hbase-slave1 \
--hostname hbase-slave1 \
--net=hadoop \
--ip 172.28.0.7 \
--privileged \
-v $PWD/conf/hbase-config:/opt/hbase-1.2.7/conf \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hbase-1.2.7 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 重新创建容器hbase-slave2..." 

docker rm -f hbase-slave2 &> /dev/null

docker run -itd \
--name hbase-slave2 \
--hostname hbase-slave2 \
--net=hadoop \
--ip 172.28.0.8 \
--privileged \
-v $PWD/conf/hbase-config:/opt/hbase-1.2.7/conf \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hbase-1.2.7 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "完成" 
echo "==> 重新创建容器hbase-slave3..." 

docker rm -f hbase-slave3 &> /dev/null
docker run -itd \
--name hbase-slave3 \
--hostname hbase-slave3 \
--net=hadoop \
--ip 172.28.0.11 \
--privileged \
-v $PWD/conf/hbase-config:/opt/hbase-1.2.7/conf \
-v $PWD/conf/hosts:/etc/hosts \
sampx/hbase-1.2.7 \
/bin/bash -c 'service ssh start && /bin/bash'

echo "==> 等待Hadoop启动完成..." 
until $(curl -m 3 --output /dev/null --silent --head --fail http://localhost:8088); do
    echo -n "." 
    sleep 1 
done
echo "完成" 

echo "==> 启动HBASE..." 
docker exec -it hbase-master bash -c 'hbase-config.sh && hbase-daemons.sh --config /opt/hbase-1.2.7/conf autorestart zookeeper &&
  hbase-daemon.sh --config /opt/hbase-1.2.7/conf autorestart master && 
  hbase-daemons.sh --config /opt/hbase-1.2.7/conf \
    --hosts /opt/hbase-1.2.7/conf/regionservers autorestart regionserver && 
  hbase-daemons.sh --config /opt/hbase-1.2.7/conf \
    --hosts "$HBASE_HOME/conf/backup-masters" autorestart master-backup'

echo "==> 等待HBASE启动完成..." 
until $(curl -m 3 --output /dev/null --silent --head --fail http://localhost:16010); do
    echo -n "." 
    sleep 1 
done
echo "完成" 
