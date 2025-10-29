--------------- put data ------------------------------------
aws kinesis put-record --stream-name DemoStream --partition-key user1 --data "user signup" --cli-binary-format raw-in-base64-out
------result ---------
{
    "ShardId": "shardId-000000000000",
    "SequenceNumber": "49668462440323373902493149870846639176529702673790795778"
}
--------------- describe the stream ------------
aws kinesis describe-stream --stream-name DemoStream
------result ---------
{
    "StreamDescription": {
        "Shards": [
            {
                "ShardId": "shardId-000000000000",
                "HashKeyRange": {
                    "StartingHashKey": "0",
                    "EndingHashKey": "340282366920938463463374607431768211455"
                },
                "SequenceNumberRange": {
                    "StartingSequenceNumber": "49668462440323373902484263141124684096996614643352862722"
                }
            }
        ],
        "StreamARN": "arn:aws:kinesis:us-east-1:288987070945:stream/DemoStream",
        "StreamName": "DemoStream",
        "StreamStatus": "ACTIVE",
        "RetentionPeriodHours": 24,
        "EnhancedMonitoring": [
            {
                "ShardLevelMetrics": []
            }
        ],
        "EncryptionType": "NONE",
        "KeyId": null,
        "StreamCreationTimestamp": "2025-10-29T09:33:37+01:00"
    }
}
--------------- Consume the data ------------
aws kinesis get-shard-iterator --stream-name DemoStream --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON
------result ---------
{
    "ShardIterator": "AAAAAAAAAAHz9pCSxheiW61typgtoLA9uabenSJ1wHFRzF3fQf43EeKxf5NRi5HsYX94TWsQrZB+Qi8aCDMggF6borV9IqtPTp0HPGf6m4luLO2+9mWJ69tZzsxz7ZVMN3iuVlwMbdHWzDELn1rGsUVjw1/Mm5c5+gLAQNhXmkUtdbEqA7ACgoDM69UoPkfKbgy3n1uQTc4kCZMoslxTGPRMUAo43uvWF/+Bbosw4/6xMBx2i8koAw=="
}
------
aws kinesis get-records --shard-iterator "AAAAAAAAAAHz9pCSxheiW61typgtoLA9uabenSJ1wHFRzF3fQf43EeKxf5NRi5HsYX94TWsQrZB+Qi8aCDMggF6borV9IqtPTp0HPGf6m4luLO2+9mWJ69tZzsxz7ZVMN3iuVlwMbdHWzDELn1rGsUVjw1/Mm5c5+gLAQNhXmkUtdbEqA7ACgoDM69UoPkfKbgy3n1uQTc4kCZMoslxTGPRMUAo43uvWF/+Bbosw4/6xMBx2i8koAw=="
------result ---------
{
    "Records": [
        {
            "SequenceNumber": "49668462440323373902493149870846639176529702673790795778",
            "ApproximateArrivalTimestamp": "2025-10-29T09:42:56.227000+01:00",
            "Data": "dXNlciBzaWdudXA=",
            "PartitionKey": "user1"
        },
        {
            "SequenceNumber": "49668462440323373902493149870847848102349318471196606466",
            "ApproximateArrivalTimestamp": "2025-10-29T09:43:14.292000+01:00",
            "Data": "dXNlciBzaWdudXA=",
            "PartitionKey": "user1"
        }
    ],
    "NextShardIterator": "AAAAAAAAAAH72AELPUFPaaMXOwhBCDTntVy6sdtwFKJULC2tKiQXCZpiI53iQLClpLGVE32opPuoX84tU/C9qRd4/J4VFGOCUq65e2oDi4U7PqeQtQGDfdVkj6r7q8fwf52vOv2yboYQRas9UMxWNAEgw7KAbJ5wGrKkz8pe4xAE5g137txGcz93h9PXs4IXsDUlW62GAUKeselrdwuGxbccaQ8vCQWYzZUvfZG7ZHHkz3WZ30v75w==",
    "MillisBehindLatest": 0
}
