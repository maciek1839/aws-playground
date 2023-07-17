#!/bin/bash
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
    awslocal --endpoint-url=http://localhost:4566 sqs create-queue --queue-name ${QUEUE_NAME_TO_CREATE} --attributes VisibilityTimeout=30
}

create_queue $SQS_1
create_queue $SQS_2

echo $(awslocal --endpoint-url=http://localhost:4566 sqs list-queues)

echo "Initialized."
