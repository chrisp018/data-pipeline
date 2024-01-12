# Building a Data Warehouse using AWS Redshift
## Project structure
### Project contains seven files:
* blob/data-pipeline-architecture.drawio: an diagram illustrates how data is loaded from Sparkify souce to Redshift datawarehouse followed by an visualization tool supporting for visual data
* create_tables.py: drop tables in Amazon Redshift in case it already exist and create tables. The scipts will be run before each time running ETL scripts for loading data to Redshift.
* sql_queries.py: contains all the query command, data is loaded to Redshift from S3
* README.md provide information about project and step instructions how to run it

## Run The Project
Synchonize data:
* Synchonize data from Sparkify to Data Lake (S3) using AWS cli s3 sync command
Create Tables in Redshift:
* Run the create_tables

## Scripts - Draft
Create a connection to Redshift Datawarehouse

```
  import psycopg2
  conn = psycopg2.connect("host='ktdl-redshift-cluster-1.cfl4l9luhdaw.ap-southeast-1.redshift.amazonaws.com' dbname=dev user=clphan password=Clphan259 port=5439")

  cur = conn.cursor()
  query = 
  cur.execute(query)
  conn.commit()

  conn.close()
```

Connect to Redshift using psql
```psql -h ktdl-redshift-cluster-1.cfl4l9luhdaw.ap-southeast-1.redshift.amazonaws.com -U clphan -d dev -p 5439
```


