#!/bin/bash
sudo hostnamectl set-hostname ${nodename}
# Install tmux
sudo yum install -y 
sudo yum install -y tmux 

# Install java 11 
sudo amazon-linux-extras enable java-openjdk11
sudo yum install -y java-11-openjdk

# Install git
sudo yum update -y
sudo yum install -y git

# Copy file from S3 to server 
mkdir /tmp/data-replay
aws s3 cp s3://bigdata-kinesis-flink-app/kinesis-replay-data-stream/amazon-kinesis-replay-1.0-SNAPSHOT.jar \
  /tmp/data-replay/amazon-kinesis-replay-1.0-SNAPSHOT.jar

mv /tmp/data-replay/amazon-kinesis-replay-1.0-SNAPSHOT.jar /tmp/data-replay/amazon-kinesis-replay.jar