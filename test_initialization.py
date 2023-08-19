# These tests aimed to verify if the initialization script (localstack/init-aws.sh) is executed successfully
# after running Localstack on GitLab or locally.
import unittest

import boto3
import os

from boto3.dynamodb.conditions import Key

table1 = "aws-playground-partition-key"
table2 = "aws-playground-partition-and-sort-keys"
table3 = "aws-playground-partition-and-sort-keys-gsi"
table4 = "aws-playground-partition-and-sort-keys-lsi"

# -------------

endpoint = os.getenv("AWS_ENDPOINT_URL", "http://localhost:4566")
region = "eu-central-1"

# DynamoDB Client
dynamodb_client = boto3.client("dynamodb", region_name=region, endpoint_url=endpoint)
# Kinesis Client
kinesis = boto3.client("kinesis", region_name=region, endpoint_url=endpoint)

# DynamoDB Table Resource
dynamodb = boto3.resource("dynamodb", region_name=region, endpoint_url=endpoint)
# S3 Resource
s3 = boto3.resource("s3", region_name=region, endpoint_url=endpoint)
# SQS Resource
sqs = boto3.resource("sqs", region_name=region, endpoint_url=endpoint)
# CloudWatch Resource
cloudwatch = boto3.resource("cloudwatch", region_name=region, endpoint_url=endpoint)


class DynamoDBTest(unittest.TestCase):
    def test_should_create_all_dynamodb_tables(self):
        def extract_table_name(t):
            return t.name

        expected_names = [
            "aws-playground-partition-key",
            "aws-playground-partition-and-sort-keys",
            "aws-playground-partition-and-sort-keys-gsi",
            "aws-playground-partition-and-sort-keys-lsi",
        ]

        actual_tables = list(dynamodb.tables.all())
        actual_names = list(map(extract_table_name, actual_tables))
        assert len(actual_tables) == 4
        self.assertListEqual(sorted(actual_names), sorted(expected_names), None)

    def test_should_query_table_1(self):
        response = dynamodb_client.get_item(
            TableName=table1,
            Key={"Id": {"S": "ed39ca64-1deb-4d31-9fa5-f062575e5be3"}},
        )
        assert response["Item"]["Id"]["S"] == "ed39ca64-1deb-4d31-9fa5-f062575e5be3"
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

    def test_should_query_table_2(self):
        table = dynamodb.Table(table2)
        response = table.query(
            KeyConditionExpression=Key("Artist").eq("No One You Know")
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

    def test_should_query_table_3(self):
        table = dynamodb.Table(table3)
        response = table.query(
            KeyConditionExpression=Key("Artist").eq("No One You Know")
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

    def test_should_query_gsi_for_table_3(self):
        table = dynamodb.Table(table3)
        response = table.query(
            IndexName="AlbumTitle-index",
            KeyConditionExpression=Key("AlbumTitle").eq("Somewhat Famous"),
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

    def test_should_query_table_4(self):
        table = dynamodb.Table(table4)
        response = table.query(
            KeyConditionExpression=Key("Artist").eq("No One You Know")
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

    def test_should_query_gsi_for_table_4(self):
        table = dynamodb.Table(table4)
        response = table.query(
            IndexName="AlbumTitle-index",
            KeyConditionExpression=Key("AlbumTitle").eq("Somewhat Famous"),
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

    def test_should_query_lsi1_for_table_4(self):
        table = dynamodb.Table(table4)
        response = table.query(
            IndexName="ArtistAwardsKeysOnly-index",
            KeyConditionExpression=Key("Artist").eq("No One You Know"),
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

        assert response["Items"][0]["Artist"] != None
        assert response["Items"][0]["Awards"] != None
        assert ("Id" in response["Items"][0]) == False
        assert ("AlbumTitle" in response["Items"][0]) == False

    def test_should_query_lsi2_for_table_4(self):
        table = dynamodb.Table(table4)
        response = table.query(
            IndexName="ArtistAwardsInclude-index",
            KeyConditionExpression=Key("Artist").eq("No One You Know"),
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

        assert response["Items"][0]["Artist"] != None
        assert response["Items"][0]["Awards"] != None
        assert response["Items"][0]["Id"] != None
        assert ("AlbumTitle" in response["Items"][0]) == False

    def test_should_query_lsi3_for_table_4(self):
        table = dynamodb.Table(table4)
        response = table.query(
            IndexName="ArtistAwardsAll-index",
            KeyConditionExpression=Key("Artist").eq("No One You Know"),
        )
        assert len(response["Items"]) == 2
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200

        assert response["Items"][0]["Artist"] != None
        assert response["Items"][0]["Awards"] != None
        assert response["Items"][0]["Id"] != None
        assert response["Items"][0]["AlbumTitle"] != None


class S3Test(unittest.TestCase):
    def test_should_create_all_s3_buckets(self):
        expected_names = ["aws-playground-bucket-1", "aws-playground-bucket-2"]

        actual_names = [bucket.name for bucket in s3.buckets.all()]

        assert len(actual_names) == 2
        self.assertListEqual(sorted(actual_names), sorted(expected_names), None)

    def test_should_create_corresponding_cloudwatch_metrics(self):
        actual_names = [str(metric) for metric in cloudwatch.metrics.all()]

        assert len(actual_names) > 0


class SqsTest(unittest.TestCase):
    def test_should_create_all_queues(self):
        expected_names = ["aws-playground1", "aws-playground2"]

        actual_names = [queue.url.split("/")[-1] for queue in sqs.queues.all()]

        assert len(actual_names) == 2
        self.assertListEqual(sorted(actual_names), sorted(expected_names), None)


class KinesisTest(unittest.TestCase):
    def test_should_create_all_streams(self):
        response = kinesis.describe_stream(StreamName="aws-playground-stream-1")
        shard_id = response["StreamDescription"]["Shards"][0]["ShardId"]
        assert shard_id == "shardId-000000000000"
