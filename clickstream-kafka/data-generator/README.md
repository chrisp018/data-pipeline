## Test connection
- Create topic
```
sh ./kafka/bin/kafka-topics.sh --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic CLICKSTREAM-TEST-CONFIG --create --partitions 3 --replication-factor 2
```
- Generate some data
```
sh ./kafka/bin/kafka-console-producer.sh --broker-list kafka1:9092,kafka2:9092,kafka3:9092 --topic CLICKSTREAM-TEST-CONFIG

{"device_id": "123", "device_name": "phone"}
{"device_id": "234", "device_name": "mobile"}
{"device_id": "345", "device_name": "laptop"}
```
- Get data
```
sh ./kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic CLICKSTREAM-TEST-CONFIG --from-beginning
```

## Steps start demo
1. Create kafka topic 
```
sh ./kafka/bin/kafka-topics.sh --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic SOURCE_SQL_TOPIC_001 --create --partitions 3 --replication-factor 2
```
2. Get list of topics to check whether the topic created or not
```
sh ./kafka/bin/kafka-topics.sh --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --list
```
3. Start stream data to the kafka
```
cd mgmt
python3 main.py
```