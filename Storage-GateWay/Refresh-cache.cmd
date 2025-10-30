aws storagegateway refresh-cache \
  --file-share-arn arn:aws:storagegateway:us-east-1:123456789012:share/share-ABC123

------------ Or ---------------
import os, boto3
sg = boto3.client("storagegateway")
# چند ARN را با کامای انگلیسی در متغیر محیطی بگذار: FILE_SHARE_ARNS=arn1,arn2
def lambda_handler(event, context):
    # FILE_SHARE_ARNS => arn:aws:storagegateway:eu-west-1:111122223333:share/share-ABC123, arn:aws:storagegateway:eu-west-1:111122223333:share/share-XYZ789
    arns = [a.strip() for a in os.environ["FILE_SHARE_ARNS"].split(",") if a.strip()]
    results = []
    for arn in arns:
        resp = sg.refresh_cache(FileShareARN=arn, FolderList=[], Recursive=True)
        results.append({"arn": arn, "status": "started", "task": resp.get("NotificationId")})
    return {"ok": True, "results": results}

