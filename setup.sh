#!/bin/bash
docker rm server node1 node2 || true
docker build -t eg_sshd .
docker network create -d bridge ansible || true
docker run -d -P --name server --network ansible eg_sshd
docker run -d -P --name node1 --network ansible eg_sshd
docker run -d -P --name node2 --network ansible eg_sshd

SERVER_PORT=`docker port server 22 | awk -F ':' '{print $2}'`
NODE1=`docker port node1 22 | awk -F ':' '{print $2}'`
NODE2=`docker port node2 22 | awk -F ':' '{print $2}'`
#ssh root@$IP_ADDR -p $SERVER_PORT " apt-get update && apt-get install ansible vim -y "
> hosts
echo '[servers]'  >> hosts
echo "node1 ansible_host=node1 ansible_password=123123" >> hosts
echo "node2 ansible_host=node2 ansible_password=123123" >> hosts
docker cp hosts server:/etc/ansible/hosts
FolderLocation=`pwd`
echo $FolderLocation
docker cp $FolderLocation  server:/root/
> Instances
echo "----------------------------" >> Instances
echo -e "- Ansible Port is $SERVER_PORT \n- Node 1 Port is $NODE1\n- Node 2 Port is $NODE2" >> Instances
echo "----------------------------" >> Instances
cat Instances
echo "ssh root@$IP_ADDR -p $SERVER_PORT"

