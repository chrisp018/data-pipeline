sed 's/<Management_Public_IP>/13.250.32.231/g' kafka_topic_ui.yml > kafka_topic_ui_replace.yml
rm kafka_topic_ui.yml
mv kafka_topic_ui_replace.yml kafka_topic_ui.yml