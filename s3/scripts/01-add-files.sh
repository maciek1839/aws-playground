echo "########## S3 add items ##########"
aws --region eu-central-1 --endpoint-url http://localhost:4566 s3 cp ../README.md s3://aws-playground-bucket-1

echo "S3 bucket content:"
aws --region eu-central-1 --endpoint-url http://localhost:4566 s3 ls s3://aws-playground-bucket-1

