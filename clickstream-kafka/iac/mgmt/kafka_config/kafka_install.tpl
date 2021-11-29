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

# Install Kafka boot scripts
sudo cp ${HOME_PATH}/mgmt/kafka_service.sh /etc/init.d/kafka
sudo chmod +x /etc/init.d/kafka
sudo chown root:root /etc/init.d/kafka
sudo update-rc.d kafka defaults

# edit the kafka settings
rm ${HOME_PATH}/kafka/server.properties
cp ${HOME_PATH}/mgmt/server.properties ${HOME_PATH}/kafka/config/server.properties

# create data directory for kafka
sudo mkdir -p /data/kafka
sudo chown -R ${USER}:${USER} /data/

# restart the zookeeper service
sudo service kafka stop
sudo service kafka start