-------------Service Provider-----------------------
aws elbv2 create-load-balancer \
  --name my-nlb \
  --type network \
  --subnets subnet-111aaa subnet-222bbb
aws elbv2 create-target-group \
  --name my-nlb-tg \
  --protocol TCP \
  --port 8080 \
  --vpc-id vpc-provider
aws ec2 create-vpc-endpoint-service-configuration \
  --network-load-balancer-arns arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/my-nlb/abc123 \
  --acceptance-required
------------------Service Consumer------------------
aws ec2 create-vpc-endpoint \
  --vpc-id vpc-consumer \
  --vpc-endpoint-type Interface \
  --service-name com.amazonaws.vpce.us-east-1.vpce-svc-0abc123def456789 \
  --subnet-ids subnet-111aaa subnet-222bbb \
  --security-group-ids sg-123abc
