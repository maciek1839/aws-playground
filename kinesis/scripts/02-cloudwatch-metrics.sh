echo "########## CloudWatch metrics for Kinesis ##########"
aws cloudwatch list-metrics --region eu-central-1 --endpoint-url http://localhost:4566 --namespace "AWS/KinesisAnalytics"
ws kinesis get-rercords
