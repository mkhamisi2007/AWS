--------- create replica ---------------
aws rds create-db-instance-read-replica \
  --db-instance-identifier mydb-replica1 \
  --source-db-instance-identifier mydb-master
--------- remove replica ---------------
aws rds delete-db-instance --db-instance-identifier mydb-replica1
--------- Promote replica ---------------
aws rds promote-read-replica \
  --db-instance-identifier my-read-replica
--------- Multi AZ (Disaster Recovery)---------------
aws rds create-db-instance \
  --db-instance-identifier prod-db \
  --multi-az \
  --engine mysql \
  --master-username admin \
  --master-user-password MyPassword123
------OR enable for existing database-------
aws rds modify-db-instance \
  --db-instance-identifier prod-db \
  --multi-az \
  --apply-immediately

