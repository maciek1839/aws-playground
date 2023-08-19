echo "########## Kinesis 'aws-playground-stream-1' ##########"
aws kinesis put-record --region eu-central-1 --endpoint-url http://localhost:4566 --stream-name aws-playground-stream-1 --data '{"symbol":"TEST","sampleno":42}' --partition-key test1
