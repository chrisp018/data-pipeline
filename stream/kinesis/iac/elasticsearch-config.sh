# create ES indices

cat stream-resources/trip_duration.json | \
  curl -s -w "\n" -XPUT https://search-bigdata-visualize-stream-nuby2pdiec4nvonr6yfbvcfbie.ap-southeast-1.es.amazonaws.com/trip_duration -H "Content-Type: application/json" -d @-

cat stream-resources/pickup_count.json | \ | \
  curl -s -w "\n" -XPUT https://search-bigdata-visualize-stream-nuby2pdiec4nvonr6yfbvcfbie.ap-southeast-1.es.amazonaws.com/pickup_count -H "Content-Type: application/json" -d @-

# create Kinaba visualizations and dashboard
cat stream-resources/streaming-analytics-workshop-dashboard.json | \
  curl -s -w "\n" -XPOST https://search-streamdomain-ls5szojgkiwndew6wcknqwosti.ap-southeast-1.es.amazonaws.com/_plugin/kibana/api/saved_objects/_bulk_create -H 'Content-Type: application/json' -H 'kbn-xsrf: true' -d @-

# set default Kibana index pattern
curl -s -w "\n" -XPOST 'https://search-streamdomain-ls5szojgkiwndew6wcknqwosti.ap-southeast-1.es.amazonaws.com/_plugin/kibana/api/kibana/settings' \
  -H 'content-type: application/json' -H 'kbn-xsrf: true' --data '{"changes":{"defaultIndex":"trip-duration-index-pattern"}}'