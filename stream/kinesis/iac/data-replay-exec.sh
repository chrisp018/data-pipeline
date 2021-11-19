#!/bin/bash
java -jar /tmp/data-replay/amazon-kinesis-replay.jar \
  -objectPrefix artifacts/kinesis-analytics-taxi-consumer/taxi-trips-partitioned.json.lz4/dropoff_year=2018/ \
  -speedup 720 -streamName bigdata_ingression_stream
