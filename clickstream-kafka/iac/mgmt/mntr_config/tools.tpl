#!/bin/bash
HOME_PATH="/home/ubuntu"
USER="ubuntu"

sudo apt-get update

# Install kafka client
sudo apt-get update && \
      sudo apt-get -y install wget ca-certificates zip net-tools vim nano tar netcat

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Java Open JDK 8
sudo apt-get -y install openjdk-8-jdk
java -version

# Disable RAM Swap
sudo sysctl vm.swappiness=1
echo 'vm.swappiness=1' | sudo tee --append /etc/sysctl.conf

# download Zookeeper and Kafka
cd ${HOME_PATH}
wget https://dlcdn.apache.org/kafka/3.0.0/kafka_2.12-3.0.0.tgz
tar -xvzf kafka_*.tgz
rm kafka_*.tgz
mv kafka_* kafka

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# set up the stable repository.
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
  
# install docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-compose

# give ubuntu permissions to execute docker
sudo usermod -aG docker ubuntu