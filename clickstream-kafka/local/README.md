## Create confluent local service 
* Create ksql server 
```
confluent local services ksql-server start
```

* Check status of service 
```
confluent local services status
```
* To easier to connect to confluent registry we can use landoop 
```
docker run --rm -it -p 8000:8000 \
           -e "CONNECT_URL=http://18.142.49.241" \
           landoop/kafka-connect-ui
```
```
docker run -d -p 2181:2181 -p 3030:3030 -p 8081-8083:8081-8083 \
           -p 9581-9585:9581-9585 -p 9092:9092 -e ADV_HOST=18.142.49.241 \
           -e RUNNING_SAMPLEDATA=1 lensesio/fast-data-dev
```
```
docker run --rm --net=host -e ADV_HOST=18.142.49.241 lensesio/fast-data-dev
```

docker run -d -p 2181:2181 -p 3030:3030 -p 8081-8083:8081-8083 \
           -p 9581-9585:9581-9585 -p 9092:9092 -e ADV_HOST=18.142.49.241 \
           -e RUNNING_SAMPLEDATA=1 lensesio/fast-data-dev