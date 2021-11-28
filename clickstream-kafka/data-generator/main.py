import random
import datetime
import time
import json
from kafka import KafkaProducer

BROKER_HOSTNAME = 'localhost'
BROKER_PORT = '9092'
def getReferrer():
    x = random.randint(1,5)
    x = x*50 
    y = x+30 
    data = {}
    data['user_id'] = random.randint(x,y)
    data['device_id'] = random.choice(['mobile','computer', 'tablet', 'mobile','computer'])
    data['client_event'] = random.choice(['beer_vitrine_nav','beer_checkout','beer_product_detail',
    'beer_products','beer_selection','beer_cart'])
    now = datetime.datetime.now()
    str_now = now.isoformat()
    data['client_timestamp'] = str_now
    return data

def main():
    print("Start sending...!")
    while(True):
        jsdata = getReferrer()
        strdata = json.dumps(jsdata)
        producer = KafkaProducer(bootstrap_servers='{}:{}'.format(BROKER_HOSTNAME, BROKER_PORT))
        # rs = producer.send('USERS', key=jsdata.get("Name").encode('utf-8'), value=strdata.encode('utf-8'))
        rs = producer.send('SOURCE_SQL_STREAM_001', value=strdata.encode('utf-8'))
        rs = rs.get(timeout=60)
        print("data: {}".format(jsdata))
        # print("result: {}".format(rs))
        time.sleep(10)


if __name__ == "__main__":
    main()