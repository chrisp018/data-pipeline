#!/bin/bash
echo "Start sync data from source data to Data Lake"
aws s3 sync s3://udacity-dend/log_data s3://ktdl-source-data/ktdl-dataset/log_data
aws s3 sync s3://udacity-dend/log_json_path.json s3://ktdl-source-data/ktdl-dataset/log_json_path.json
aws s3 sync s3://udacity-dend/song_data s3://ktdl-source-data/ktdl-dataset/song_data
echo "Sync Finished"
