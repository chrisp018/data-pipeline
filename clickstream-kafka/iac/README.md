### Run terraform 
1. Before run terraform apply remove private_ips.txt under mgmt directory
```
terraform apply --auto-approve
```
2. Access into the instance, copy and past the content in the private_ips.txt to /etc/hosts
3. Restart all the service (kafka and zookeeper) by ssh into the server and run:
```
# kafka
sudo service kafka stop
sudo service kafka start
# zookeeper 
sudo service zookeeper stop 
sudo service zookeeper start
```
4. Add public ip of mamagement monitor instance in to kafka topic ui "<Management_Public_IP>"
```
sed 's/<Management_Public_IP>/13.250.32.141/g' kafka_topic_ui.yml > kafka_topic_ui_replace.yml
rm kafka_topic_ui.yml
mv kafka_topic_ui_replace.yml kafka_topic_ui.yml
```
5. Run docker compose for files
```
cd mgmt
docker-compose -f kafka_topic_ui.yml up -d
docker-compose -f kafka_manager.yml up -d
docker-compose -f zoonavigator.yml up -d
```
6. Acess KSQL CLI
```
docker-compose -f kafka_topic_ui.yml exec kafka-ksql-cli  ksql http://ksqldb-server:8088
```