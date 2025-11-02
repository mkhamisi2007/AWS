# S3 bucket 
aws s3api create-bucket --bucket my-config-bucket

# Delivery Channel
aws configservice put-delivery-channel \
  --delivery-channel-name default \
  --s3-bucket my-config-bucket

#  Configuration Recorder
aws configservice put-configuration-recorder \
  --configuration-recorder name=default,roleARN=arn:aws:iam::123456789012:role/config-role

aws configservice start-configuration-recorder \
  --configuration-recorder-name default
