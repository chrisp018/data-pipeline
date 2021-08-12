# data-engineer: Building a Data Warehouse using AWS Redshift
Source data is from AWS S3, the data will be moved to AWS Redshift by using python script.
After data is loaded into the Redshift DW, we can use Quicksight for Business analysist.

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


