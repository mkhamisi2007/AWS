---------------------ECS--------------------------------
aws application-autoscaling register-scalable-target \
  --service-namespace ecs \
  --resource-id service/my-cluster/my-service \
  --scalable-dimension ecs:service:DesiredCount \
  --min-capacity 1 \
  --max-capacity 10
---------------------Aurora--------------------------------
aws application-autoscaling register-scalable-target \
  --service-namespace rds \
  --resource-id cluster:my-aurora-cluster \
  --scalable-dimension rds:cluster:ReadReplicaCount \
  --min-capacity 2 \
  --max-capacity 15

-----------------------DynamoDB------------------------------
aws application-autoscaling register-scalable-target \
  --service-namespace dynamodb \
  --resource-id table/MyDynamoDBTable \
  --scalable-dimension dynamodb:table:ReadCapacityUnits \
  --min-capacity 5 \
  --max-capacity 100

-----------------------Lambda------------------------------
aws application-autoscaling register-scalable-target \
  --service-namespace lambda \
  --resource-id function:my-function:prod \
  --scalable-dimension lambda:function:ProvisionedConcurrency \
  --min-capacity 1 \
  --max-capacity 10

