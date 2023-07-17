echo "########## Queue 1 ########## "
aws --endpoint http://localhost:4566 --region eu-central-1 sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/aws-playground1 --attribute-names All

echo "########## Queue 2 ########## "
aws --endpoint http://localhost:4566 --region eu-central-1 sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/aws-playground2 --attribute-names All
