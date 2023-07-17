echo "########### aws-playground-partition-key ###########"

echo "Executing 1 query for 'aws-playground-partition-key' ..."
aws dynamodb get-item --region eu-central-1 --endpoint-url http://localhost:4566 --consistent-read \
    --table-name aws-playground-partition-key \
    --key '{ "Id": {"S": "60a124fc-28a6-4dda-9715-b6163c9605d2"}}'

echo "Executing 2 for 'aws-playground-partition-key' - not possible to filter out based on artists..."

echo "########### aws-playground-partition-and-sort-keys ###########"

echo "Executing 1 query for 'aws-playground-partition-and-sort-keys' ..."
aws dynamodb get-item --region eu-central-1 --endpoint-url http://localhost:4566 --consistent-read \
    --table-name aws-playground-partition-and-sort-keys \
    --key '{ "Artist": {"S": "Acme Band"}, "SongTitle": {"S": "Happy Day"}}'

echo "Executing 2  for 'aws-playground-partition-and-sort-keys' ..."
aws dynamodb query --region eu-central-1 --endpoint-url http://localhost:4566 \
    --table-name aws-playground-partition-and-sort-keys \
    --key-condition-expression "Artist = :name" \
    --expression-attribute-values  '{":name":{"S":"Acme Band"}}'

echo "########### aws-playground-partition-and-sort-keys-gsi ###########"

echo "Executing 1 query for 'aws-playground-partition-and-sort-keys-gsi' ..."
aws dynamodb query --region eu-central-1 --endpoint-url http://localhost:4566 \
    --table-name aws-playground-partition-and-sort-keys-gsi \
    --index-name AlbumTitle-index \
    --key-condition-expression "AlbumTitle = :name" \
    --expression-attribute-values  '{":name":{"S":"Somewhat Famous"}}'

echo "########### aws-playground-partition-and-sort-keys-lsi ###########"

echo "Executing 1 query for 'aws-playground-partition-and-sort-keys-lsi' on ArtistAwardsKeysOnly-index ..."
aws dynamodb query --region eu-central-1 --endpoint-url http://localhost:4566 \
    --table-name aws-playground-partition-and-sort-keys-lsi \
    --index-name ArtistAwardsKeysOnly-index \
    --key-condition-expression "Artist = :name" \
    --no-scan-index-forward  \
    --expression-attribute-values  '{":name":{"S":"Acme Band"}}'

echo "Executing 2 query for 'aws-playground-partition-and-sort-keys-lsi' on ArtistAwardsInclude-index ..."
aws dynamodb query --region eu-central-1 --endpoint-url http://localhost:4566 \
    --table-name aws-playground-partition-and-sort-keys-lsi \
    --index-name ArtistAwardsInclude-index \
    --key-condition-expression "Artist = :name" \
    --no-scan-index-forward  \
    --expression-attribute-values  '{":name":{"S":"Acme Band"}}'

echo "Executing 3 query for 'aws-playground-partition-and-sort-keys-lsi' on ArtistAwardsAll-index ..."
aws dynamodb query --region eu-central-1 --endpoint-url http://localhost:4566 \
    --table-name aws-playground-partition-and-sort-keys-lsi \
    --index-name ArtistAwardsAll-index \
    --key-condition-expression "Artist = :name" \
    --no-scan-index-forward  \
    --expression-attribute-values  '{":name":{"S":"Acme Band"}}'
