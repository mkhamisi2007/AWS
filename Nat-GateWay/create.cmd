aws ec2 create-nat-gateway \
  --subnet-id subnet-0123456789abcdef0 \
  --allocation-id eipalloc-0abc12345d67890ef \
  --tag-specifications 'ResourceType=natgateway,Tags=[{Key=Name,Value=MyNATGW}]'

aws ec2 create-route \
  --route-table-id rtb-0a1b2c3d4e5f6g7h8 \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id nat-0123456789abcdef0
