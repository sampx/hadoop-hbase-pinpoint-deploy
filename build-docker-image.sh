#!/bin/bash
 
echo "==> 创建镜像sampx/ubuntu-jdk8-ssh..." 
docker build -f dockerfiles/Dockerfile.jdk8 -t sampx/ubuntu-jdk8-ssh .
echo "==> 创建镜像sampx/hadoop-2.7.6..." 
docker build -f dockerfiles/Dockerfile.hadoop -t sampx/hadoop-2.7.6 .
echo "==> 创建镜像sampx/hbase-1.2.7..." 
docker build -f dockerfiles/Dockerfile.hbase -t sampx/hbase-1.2.7 .
echo "==> 创建镜像sampx/zookeeper-3.4.10..." 
docker build -f dockerfiles/Dockerfile.zookeeper -t sampx/zookeeper-3.4.10 .
echo "==> 创建镜像sampx/tomcat-8.5..." 
docker build -f dockerfiles/Dockerfile.tomcat -t sampx/tomcat-8.5 .
echo "==> 创建镜像sampx/pinpoint-collector-1.8.0..." 
docker build -f dockerfiles/Dockerfile.pinpoint-collector -t sampx/pinpoint-collector-1.8.0 .
echo "==> 创建镜像sampx/sampx/pinpoint-web-1.8.0..." 
docker build -f dockerfiles/Dockerfile.pinpoint-web -t sampx/pinpoint-web-1.8.0 .
echo "==> 完成." 
