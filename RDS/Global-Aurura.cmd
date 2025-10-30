aws rds create-global-cluster \
  --global-cluster-identifier my-global-aurora \
  --source-db-cluster-identifier arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster
---------------------------------
aws rds create-db-cluster \
  --db-cluster-identifier my-secondary-cluster \
  --engine aurora-mysql \
  --source-region us-east-1 \
  --global-cluster-identifier my-global-aurora
