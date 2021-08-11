# data-engineer

## Scripts
Create a connection to Redshift Datawarehouse

```
  import psycopg2
  conn = psycopg2.connect("host='ktdl-redshift-cluster-1.cfl4l9luhdaw.ap-southeast-1.redshift.amazonaws.com' dbname=dev user=clphan password=Clphan259 port=5439")

  query = "show tables"
  cur.execute(query)

  cur = conn.cursor()

  conn.close()
```


