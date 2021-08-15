import configparser
import psycopg2
from sql_queries import copy_table_queries, insert_table_queries, copy_staging_order, count_staging_queries, insert_table_order, count_fact_dim_queries


# Loading data to staging
def load_staging_tables(cur, conn):
    for idx, query in enumerate (copy_table_queries):
        cur.execute(query)
        conn.commit()

def insert_tables(cur, conn):
    for idx, query in enumerate(insert_table_queries):
        cur.execute(query)
        conn.commit()


def main():
    config = configparser.ConfigParser()
    config.read('dwh.cfg')


    conn = psycopg2.connect("host={} dbname={} user={} password={} port={}".format(*config['CLUSTER'].values()))
    cur = conn.cursor()


    load_staging_tables(cur, conn)
    insert_tables(cur, conn)
    print("Load data successfully")

    conn.close()

if __name__ == "__main__":
    main()