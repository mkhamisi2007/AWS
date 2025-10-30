aws dynamodb create-global-table \
  --global-table-name UsersGlobal \
  --replication-group RegionName=us-east-1 RegionName=ap-southeast-2

