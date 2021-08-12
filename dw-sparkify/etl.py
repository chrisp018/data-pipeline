import configparser
import psycopg2
from sql_queries import copy_table_queries, insert_table_queries, copy_staging_order, count_staging_queries, insert_table_order, count_fact_dim_queries


# Loading data to staging
def load_staging_tables(cur, conn):
    for idx, query in enumerate (copy_table_queries):
        cur.execute(query)
        conn.commit()
        row = cur.execute(count_staging_queries[idx])
        print('No. of rows copied into {}: {}'.format(copy_staging_order[idx], row.count))


def main():
  config = configparser.ConfigParser()
  config.read('dwh.cfg')


  conn = psycopg2.connect("host={} dbname={} user={} password={} port={}".format(*config['CLUSTER'].values()))
  cur = conn.cursor()


  load_staging_tables(cur, conn)


  conn.close()

if __name__ == "__main__":
    main()