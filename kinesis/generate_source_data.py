#
# Ref: https://github.com/apache/flink-playgrounds/blob/master/pyflink-walkthrough/generator/generate_source_data.py
#
import calendar
import json
import random
import time
from random import randint
from time import sleep

import boto3

from test_common import region, endpoint


def write_data(kinesis_stream_name):
    kinesis = boto3.client("kinesis", region_name=region, endpoint_url=endpoint)
    data_cnt = 1000
    order_id = calendar.timegm(time.gmtime())
    max_price = 10_000
    print(f"Starting record publishing to {kinesis_stream_name}")
    sleep(1)

    for i in range(data_cnt):
        print(f"Publishing record {i}")
        ts = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        rd = random.random()
        order_id += 1
        pay_amount = max_price * rd
        pay_platform = 0 if random.random() < 0.9 else 1
        province_id = randint(0, 6)
        cur_data = {
            "createTime": ts,
            "orderId": order_id,
            "payAmount": pay_amount,
            "payPlatform": pay_platform,
            "provinceId": province_id,
            "providerId": random.choice(["CHOICE_1", "CHOICE_2"]),
        }
        response = kinesis.put_record(
            StreamName=kinesis_stream_name, Data=json.dumps(cur_data), PartitionKey="1"
        )
        print(f"Response: {response}")


if __name__ == "__main__":
    write_data("aws-playground-stream-2")
