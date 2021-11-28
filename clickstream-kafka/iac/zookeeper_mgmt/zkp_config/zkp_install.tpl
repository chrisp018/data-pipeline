#!/bin/bash
HOME_PATH="/home/ubuntu"
USER="ubuntu"
# Install dependencies
sudo apt-get update && \
      sudo apt-get -y install wget ca-certificates zip net-tools vim nano tar netcat

# Java Open JDK 8
sudo apt-get -y install openjdk-8-jdk
java -version

# Disable RAM Swap
sudo sysctl vm.swappiness=1
echo 'vm.swappiness=1' | sudo tee --append /etc/sysctl.conf

# download Zookeeper and Kafka.
cd ${HOME_PATH}
wget https://dlcdn.apache.org/kafka/3.0.0/kafka_2.12-3.0.0.tgz
tar -xvzf kafka_*.tgz
rm kafka_*.tgz
mv kafka_* kafka
cd kafka/

# Install Zookeeper boot scripts
sudo cp ${HOME_PATH}/mgmt/zookeeper_service.sh /etc/init.d/zookeeper
sudo chmod +x /etc/init.d/zookeeper
sudo chown root:root /etc/init.d/zookeeper
sudo update-rc.d zookeeper defaults

# edit the zookeeper settings
rm ${HOME_PATH}/kafka/config/zookeeper.properties
cp ${HOME_PATH}/mgmt/zookeeper.properties ${HOME_PATH}/kafka/config/zookeeper.properties

# create data dictionary for zookeeper
sudo mkdir -p /data/zookeeper
sudo chown -R ${USER}:${USER} /data/
echo ${MYID} > /data/zookeeper/myid

# restart the zookeeper service
sudo service zookeeper stop
sudo service zookeeper start