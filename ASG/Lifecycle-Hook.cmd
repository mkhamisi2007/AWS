------------ Create Lifecycle-Hook and connect it to SNS -------------------
aws autoscaling put-lifecycle-hook \
  --lifecycle-hook-name TerminateHook \
  --auto-scaling-group-name MyASG \
  --lifecycle-transition autoscaling:EC2_INSTANCE_TERMINATING \
  --notification-target-arn arn:aws:sns:us-east-1:123456789012:ASGTerminateTopic \
  --role-arn arn:aws:iam::123456789012:role/AutoScalingNotificationAccessRole \
  --heartbeat-timeout 300
-------------------- Lammbda fuctioon for save Log to S3 ----------------------
import boto3
import os

s3 = boto3.client('s3')
asg = boto3.client('autoscaling')
ssm = boto3.client('ssm')

def lambda_handler(event, context):
    instance_id = event['detail']['EC2InstanceId']
    bucket = 'my-ec2-logs-bucket'
    
    # اجرای دستور روی EC2 برای خواندن لاگ‌ها (از طریق SSM)
    command = "sudo cat /var/log/syslog"
    response = ssm.send_command(
        InstanceIds=[instance_id],
        DocumentName="AWS-RunShellScript",
        Parameters={'commands': [command]}
    )
    
    command_id = response['Command']['CommandId']
    output = ssm.get_command_invocation(CommandId=command_id, InstanceId=instance_id)
    logs = output['StandardOutputContent']
    
    # آپلود لاگ در S3
    key = f"logs/{instance_id}.log"
    s3.put_object(Bucket=bucket, Key=key, Body=logs)
    
    # اعلام پایان Lifecycle Action
    asg.complete_lifecycle_action(
        LifecycleHookName='TerminateHook',
        AutoScalingGroupName='MyASG',
        LifecycleActionResult='CONTINUE',
        InstanceId=instance_id
    )
    
    return {"status": "success", "instance_id": instance_id}
---------------Connect Lambda to SNS ----------------
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789012:ASGTerminateTopic \
  --protocol lambda \
  --notification-endpoint arn:aws:lambda:us-east-1:123456789012:function:ASGLogUploader
---------------
