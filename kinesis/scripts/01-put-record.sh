echo "########## Kinesis 'samplestream' ##########"
aws kinesis put-record --region eu-central-1 --endpoint-url http://localhost:4566 --stream-name samplestream --data '{"symbol":"TEST","sampleno":42}' --partition-key test1
