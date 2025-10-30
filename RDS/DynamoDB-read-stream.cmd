aws dynamodb describe-table \
  --table-name MyTable \
  --query "Table.LatestStreamArn"
-------------------------------
aws dynamodbstreams describe-stream \
  --stream-arn arn:aws:dynamodb:us-east-1:123456789012:table/MyTable/stream/2025-10-30T09:00:00.000 \
  --query "StreamDescription.Shards[*].ShardId"
-----------------------------------
aws dynamodbstreams get-shard-iterator \
  --stream-arn arn:aws:dynamodb:us-east-1:123456789012:table/MyTable/stream/2025-10-30T09:00:00.000 \
  --shard-id shardId-000000015 \
  --shard-iterator-type TRIM_HORIZON
---------------------------------
aws dynamodbstreams get-records \
  --shard-iterator <ShardIteratorValue>
