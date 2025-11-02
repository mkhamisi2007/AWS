------------------Create User-----------------------------
aws identitystore create-user \
  --identity-store-id d-1234567890 \
  --user-name "testuser" \
  --display-name "Test User" \
  --emails '[{"Value":"testuser@example.com","Type":"work","Primary":true}]'
----------------------create Permission Set-------------------------
aws sso-admin create-permission-set \
  --instance-arn arn:aws:sso:::instance/ssoins-abc123 \
  --name "ReadOnlyAccess" \
  --description "Read-only access to AWS accounts"
-------------------------Attach permission to Permission Set----------------------
aws sso-admin attach-managed-policy-to-permission-set \
  --instance-arn arn:aws:sso:::instance/ssoins-abc123 \
  --permission-set-arn arn:aws:sso:::permissionSet/ssoins-abc123/ps-987654321 \
  --managed-policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess
------------------------Assign user to permission set-----------------------
aws sso-admin create-account-assignment \
  --instance-arn arn:aws:sso:::instance/ssoins-abc123 \
  --target-id 111122223333 \
  --target-type AWS_ACCOUNT \
  --permission-set-arn arn:aws:sso:::permissionSet/ssoins-abc123/ps-987654321 \
  --principal-type USER \
  --principal-id <USER-ID>
-------------------test login----------------------------
aws sso login --sso-start-url https://d-1234567890.awsapps.com/start --sso-region eu-west-1
