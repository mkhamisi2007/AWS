-------------MD5 algorithm--------------------------
aws s3api head-object \
  --bucket my-bucket \
  --key myfile.txt \
  --query ETag \
  --output text

--------------Other algorithm-------------------
aws s3api put-object \
  --bucket my-bucket \
  --key myfile.txt \
  --body myfile.txt \
  --checksum-algorithm SHA256

