#!/bin/bash
docker rm -f hbase-slave3 &> /dev/null
docker rm -f hbase-slave2 &> /dev/null
docker rm -f hbase-slave1 &> /dev/null
docker rm -f hbase-master &> /dev/null
docker rm -f zookeeper1 &> /dev/null
docker rm -f hadoop-slave2 &> /dev/null
docker rm -f hadoop-slave3 &> /dev/null
docker rm -f hadoop-slave1 &> /dev/null
docker rm -f hadoop-master &> /dev/null
docker network -f rm hadoop &> /dev/null