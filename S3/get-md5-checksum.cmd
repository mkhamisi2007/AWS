aws s3api head-object \
  --bucket my-bucket \
  --key myfile.txt \
  --query ETag \
  --output text
