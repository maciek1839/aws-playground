echo "########## CloudWatch metrics for SQS ##########"
aws cloudwatch list-metrics --region eu-central-1 --endpoint-url http://localhost:4566 --namespace "AWS/SQS"
