# create ES indices

curl -s https://raw.githubusercontent.com/aws-samples/amazon-kinesis-analytics-taxi-consumer/master/misc/trip-duration-index.json | \
  curl -s -w "\n" -XPUT https://search-streamdomain-ls5szojgkiwndew6wcknqwosti.ap-southeast-1.es.amazonaws.com -H "Content-Type: application/json" -d @-

curl -s https://raw.githubusercontent.com/aws-samples/amazon-kinesis-analytics-taxi-consumer/master/misc/pickup-count-index.json | \
  curl -s -w "\n" -XPUT https://search-streamdomain-ls5szojgkiwndew6wcknqwosti.ap-southeast-1.es.amazonaws.com/pickup_count -H "Content-Type: application/json" -d @-

# create Kinaba visualizations and dashboard
curl -s https://raw.githubusercontent.com/aws-samples/amazon-kinesis-analytics-taxi-consumer/master/misc/nyc-tlc-dashboard.json | \
  curl -s -w "\n" -XPOST https://search-streamdomain-ls5szojgkiwndew6wcknqwosti.ap-southeast-1.es.amazonaws.com/_plugin/kibana/api/saved_objects/_bulk_create -H 'Content-Type: application/json' -H 'kbn-xsrf: true' -H kbn-xsrf: reporting -d @-

# set default Kibana index pattern
curl -s -w "\n" -XPOST 'https://search-streamdomain-ls5szojgkiwndew6wcknqwosti.ap-southeast-1.es.amazonaws.com/_plugin/kibana/api/kibana/settings' \
  -H 'content-type: application/json' -H 'kbn-xsrf: true' --data '{"changes":{"defaultIndex":"trip-duration-index-pattern"}}'

  $ java -jar amazon-kinesis-replay-1.0.jar -streamName «Kinesis stream name» -streamRegion ap-southeast-1 -speedup 3600 -aggregate

  java -jar /tmp/data-replay/amazon-kinesis-replay.jar  -streamRegion ap-southeast-1 -speedup 3600 -aggregate -streamName bigdata_ingression_stream

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:ESHttp*",
      "Resource": "*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "54.174.220.236"
        }
      }
    }
  ]
}