#!/bin/sh
# localstack to successfully run the script.

echo "pwd: $(pwd)"
cat /etc/shells
echo "awslocal: $(awslocal --version)"
echo "########## awscli-local ##########"
pip show awscli-local

echo "LocalStack endpoint: AWS_ENDPOINT_URL - $(printenv AWS_ENDPOINT_URL) LOCALSTACK_HOSTNAME - $(printenv LOCALSTACK_HOSTNAME)"

echo "########### Setting up localstack profile ###########"
#aws configure set aws_access_key_id access_key --profile=localstack
#aws configure set aws_secret_access_key secret_key --profile=localstack
#aws configure set region eu-central-1 --profile=localstack
#aws configure set region eu-central-1 --profile=localstack
#
#echo "Default region: $(aws configure get region)"

echo "########### SQS ###########"
export SQS_1=aws-playground1
export SQS_2=aws-playground2

echo "SQS: ${SQS_1}, ${SQS_2}"

create_queue() {
    local QUEUE_NAME_TO_CREATE=$1
    awslocal sqs create-queue --queue-name ${QUEUE_NAME_TO_CREATE} --attributes VisibilityTimeout=30
}

create_queue $SQS_1
create_queue $SQS_2

echo "$(awslocal sqs list-queues)"

echo "########### DynamoDB ###########"
export DYNAMO_DB_1=aws-playground-partition-key
export DYNAMO_DB_FILE_1=1-partition-key-table.json

export DYNAMO_DB_2=aws-playground-partition-and-sort-keys
export DYNAMO_DB_FILE_2=2-partition-and-sort-keys-table.json

export DYNAMO_DB_3=aws-playground-partition-and-sort-keys-gsi
export DYNAMO_DB_FILE_3=3-partition-and-sort-keys-table-gsi.json

export DYNAMO_DB_4=aws-playground-partition-and-sort-keys-lsi
export DYNAMO_DB_FILE_4=4-partition-and-sort-keys-table-lsi.json


echo "Listing DynamoDb tables before ..."
echo "$(awslocal dynamodb list-tables)"

create_dynamodb_table() {
    local DYNAMODB_TABLE_NAME_TO_CREATE=$1
    local DYNAMODB_SCHEMA_FILE=$2
    echo "Creating  DynamoDb '${DYNAMODB_TABLE_NAME_TO_CREATE}' table ..."
    awslocal dynamodb create-table --cli-input-json file://$DYNAMODB_INIT_SCRIPTS_PATH/$DYNAMODB_SCHEMA_FILE
}

create_dynamodb_table $DYNAMO_DB_1 $DYNAMO_DB_FILE_1
create_dynamodb_table $DYNAMO_DB_2 $DYNAMO_DB_FILE_2
create_dynamodb_table $DYNAMO_DB_3 $DYNAMO_DB_FILE_3
create_dynamodb_table $DYNAMO_DB_4 $DYNAMO_DB_FILE_4

echo "Listing DynamoDb tables after ..."
echo "$(awslocal dynamodb list-tables)"

insert_data() {
    # Ref: # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/getting-started-step-2.html

    local DYNAMODB_TABLE_NAME_TO_CREATE=$1
    echo "Inserting sample data into $DYNAMODB_TABLE_NAME_TO_CREATE..."

    awslocal dynamodb put-item \
        --table-name $DYNAMODB_TABLE_NAME_TO_CREATE  \
        --item \
            '{"Id": {"S": "ed39ca64-1deb-4d31-9fa5-f062575e5be3"}, "Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Call Me Today"}, "AlbumTitle": {"S": "Somewhat Famous"}, "Awards": {"N": "1"}}'

    awslocal dynamodb put-item \
        --table-name $DYNAMODB_TABLE_NAME_TO_CREATE  \
        --item \
            '{"Id": {"S": "c0e5dc14-f1f8-470e-ac69-5443a6cee88b"}, "Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Howdy"}, "AlbumTitle": {"S": "Somewhat Famous"}, "Awards": {"N": "2"}}'

    awslocal dynamodb put-item \
        --table-name $DYNAMODB_TABLE_NAME_TO_CREATE \
        --item \
            '{"Id": {"S": "60a124fc-28a6-4dda-9715-b6163c9605d2"}, "Artist": {"S": "Acme Band"}, "SongTitle": {"S": "Happy Day"}, "AlbumTitle": {"S": "Songs About Life"}, "Awards": {"N": "10"}}'

    awslocal dynamodb put-item \
        --table-name $DYNAMODB_TABLE_NAME_TO_CREATE \
        --item \
            '{"Id": {"S": "47651c19-a1e1-4b75-a861-b0a231790f58"}, "Artist": {"S": "Acme Band"}, "SongTitle": {"S": "PartiQL Rocks"}, "AlbumTitle": {"S": "Another Album Title"}, "Awards": {"N": "8"}}'
}

insert_data $DYNAMO_DB_1
insert_data $DYNAMO_DB_2
insert_data $DYNAMO_DB_3
insert_data $DYNAMO_DB_4

echo "########### Kinesis ###########"
echo "Creating AWS Kinesis stream..."
echo "$(awslocal kinesis create-stream --stream-name samplestream --shard-count  2)"

echo "Available Kinesis streams: $(awslocal kinesis list-streams)"

echo "########### S3 ###########"
echo "Creating S3 buckets..."

export S3_BUCKET_1=aws-playground-bucket-1
export S3_BUCKET_2=aws-playground-bucket-2

echo "$(awslocal s3 mb s3://$S3_BUCKET_1)"
echo "$(awslocal s3 mb s3://$S3_BUCKET_2)"

echo "Available S3 buckets:"
awslocal s3 ls

echo "LocalStack initialized."
