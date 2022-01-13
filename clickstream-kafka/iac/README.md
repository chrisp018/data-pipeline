### Run terraform 
1. Before run terraform apply remove private_ips.txt under mgmt directory
```
terraform apply --auto-approve
```
2. Access into the instance
    * copy and past the content in the private_ips.txt to /etc/hosts
    * change broker id in kafka servers
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
sed 's/<Management_Public_IP>/13.213.72.240/g' kafka_topic_ui.yml > kafka_topic_ui_replace.yml
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
6. Access zookeeper and create cluster "clickstreamcluster"

7. Create source topic
```
sh ./kafka/bin/kafka-topics.sh --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic SOURCE_SQL_TOPIC_001 --create --partitions 3 --replication-factor 2
```

8. Setup data gen by do the test under data-generator/README.md

6. Acess KSQL CLI
```
cd mgmt
docker-compose -f kafka_topic_ui.yml exec ksqldb-cli  ksql http://ksqldb-server:8088
```

7. Apply create ksql in ksql/session_transformation.sql
```
CREATE STREAM source_sql_stream_001 ( user_id BIGINT, device_id VARCHAR, client_event VARCHAR, client_timestamp VARCHAR) WITH ( VALUE_FORMAT='JSON',KAFKA_TOPIC='SOURCE_SQL_TOPIC_001',timestamp='client_timestamp',timestamp_format='yyyy-MM-dd''T''HH:mm:ss.SSSSSS');

CREATE TABLE ENRICH_SOURCE_SQL_STREAM_001 AS SELECT cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) as session_id, AS_VALUE(cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3)) AS CLICK_SESSION, TIMESTAMPTOSTRING(WINDOWSTART,'yyyy-MM-dd HH:mm:ss', 'UTC') AS SESSION_START_TS, TIMESTAMPTOSTRING(WINDOWEND,'yyyy-MM-dd HH:mm:ss', 'UTC')   AS SESSION_END_TS, count(*) AS CLICK_COUNT, (WINDOWEND - WINDOWSTART)/1000 AS SESSION_LENGTH_MS FROM SOURCE_SQL_STREAM_001 window SESSION (30 second) GROUP BY cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) EMIT CHANGES;
```
8. Check output topic again 
```
sh ./kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic ENRICH_SOURCE_SQL_STREAM_001 --from-beginning
```
8. Connect to elasticsearch by using kafka connect ui
Before update, update IP in ElasticSearch security config
```
name=ElasticsearchSinkConnector
connector.class=io.confluent.connect.elasticsearch.ElasticsearchSinkConnector
type.name=kafka-connect
key.converter.schemas.enable=false
topics=ENRICH_SOURCE_SQL_STREAM_001
tasks.max=1
value.converter.schemas.enable=false
value.converter=org.apache.kafka.connect.json.JsonConverter
key.ignore=true
connection.url=https://search-bigdata-visualize-data-wfym2esaivjrbcwqm53sleqq64.ap-southeast-1.es.amazonaws.com
key.converter=org.apache.kafka.connect.json.JsonConverter
schema.ignore=true
behavior.on.null.values=ignore
```