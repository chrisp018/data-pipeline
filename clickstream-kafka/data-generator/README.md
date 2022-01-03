1. Create kafka topic 
```
sh ./kafka/bin/kafka-topics.sh --bootstrap-server kafka1:9092 --topic SOURCE_SQL_TOPIC_001 --create --partitions 3 --replication-factor 1
```
2. Get list of topics to check whether the topic created or not
```
sh ./kafka/bin/kafka-topics.sh --bootstrap-server kafka1:9092 --list
```
3. Start stream data to the kafka
```
python3 main.py
```
4. Check data from consumer
```
sh ./kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic SOURCE_SQL_STREAM_001 --from-beginning
```