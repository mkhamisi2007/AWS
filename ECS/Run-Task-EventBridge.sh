aws events put-rule \
  --name RunECSTaskEvery5Min \
  --schedule-expression "rate(5 minutes)"
-------------------------
aws events put-targets \
  --rule RunECSTaskEvery5Min \
  --targets '[
    {
      "Id": "RunECSTask",
      "Arn": "arn:aws:ecs:us-east-1:123456789012:cluster/my-ecs-cluster",
      "RoleArn": "arn:aws:iam::123456789012:role/EventBridgeInvokeEcsRole",
      "EcsParameters": {
        "LaunchType": "FARGATE",
        "TaskDefinitionArn": "arn:aws:ecs:us-east-1:123456789012:task-definition/my-task:1",
        "NetworkConfiguration": {
          "awsvpcConfiguration": {
            "Subnets": ["subnet-abc123"],
            "AssignPublicIp": "ENABLED"
          }
        }
      }
    }
  ]'
