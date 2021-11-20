#!/bin/bash
java -jar /home/ec2-user/amazon-kinesis-replay.jar \
  -objectPrefix artifacts/kinesis-analytics-taxi-consumer/taxi-trips-partitioned.json.lz4 \
  -speedup 600 -aggregate -streamName bigdata_ingression_stream

