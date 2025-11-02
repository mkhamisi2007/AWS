aws iam create-role \
  --role-name OrganizationAccountAccessRole \
  --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::<MANAGEMENT_ACCOUNT_ID>:root"},"Action":"sts:AssumeRole"}]}' \
  --description "Allows management account to access this member account"
  
aws iam attach-role-policy \
  --role-name OrganizationAccountAccessRole \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
