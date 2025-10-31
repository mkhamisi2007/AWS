aws synthetics create-canary \
  --name "LoginPageCanary" \
  --artifact-s3-location "s3://my-canary-results/" \
  --execution-role-arn arn:aws:iam::123456789012:role/MySyntheticsRole \
  --schedule "Expression=rate(5 minutes)" \
  --runtime-version syn-python-selenium-2.1 \
  --handler "canary_login.handler" \
  --code "S3Bucket=my-canary-code,S3Key=canary-login.zip"
