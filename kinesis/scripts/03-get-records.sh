SHARD_ITERATOR=$(aws kinesis get-shard-iterator --region eu-central-1 --endpoint-url http://localhost:4566 --stream-name samplestream --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON  | jq -r '.ShardIterator')
echo "Shard iterator: $SHARD_ITERATOR"
echo "Kinesis records: $(aws kinesis get-records --region eu-central-1 --endpoint-url http://localhost:4566 --shard-iterator $SHARD_ITERATOR | jq -r '.Records[0].Data')"

# See more: https://github.com/localstack/localstack/issues/7279
