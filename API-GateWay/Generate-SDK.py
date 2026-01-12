import os
import boto3
from datetime import datetime, timezone

apigw = boto3.client("apigateway")   # REST API (v1) client
s3 = boto3.client("s3")

BUCKET = os.environ["SDK_BUCKET"]          # e.g. my-partner-sdks
PREFIX = os.environ.get("SDK_PREFIX", "")  # e.g. "rest-api-sdks"

def lambda_handler(event, context):
    """
    Expected EventBridge event (simplified):
    event["detail"]["restApiId"]
    event["detail"]["stageName"]
    """
    detail = event.get("detail", {})
    rest_api_id = detail.get("restApiId")
    stage_name = detail.get("stageName")

    if not rest_api_id or not stage_name:
        raise ValueError(f"Missing restApiId/stageName in event: {event}")

    # Choose SDK platform (matches console dropdown options)
    sdk_type = os.environ.get("SDK_TYPE", "javascript")  # javascript|java|python|ruby|php|android|swift
    # Optional: include API Gateway custom SDK config (rarely needed)
    parameters = {}  # e.g. {"serviceName": "MyApi"}

    # Call API Gateway GetSdk (returns a streaming body)
    resp = apigw.get_sdk(
        restApiId=rest_api_id,
        stageName=stage_name,
        sdkType=sdk_type,
        parameters=parameters
    )

    body_stream = resp["body"]
    zip_bytes = body_stream.read()  # ZIP file bytes

    # Build S3 key (keep versions + a "latest" pointer style)
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    base = f"{PREFIX.strip('/')}/" if PREFIX else ""
    versioned_key = f"{base}{rest_api_id}/{stage_name}/{sdk_type}/{ts}/sdk.zip"
    latest_key = f"{base}{rest_api_id}/{stage_name}/{sdk_type}/latest/sdk.zip"

    # Upload versioned
    s3.put_object(
        Bucket=BUCKET,
        Key=versioned_key,
        Body=zip_bytes,
        ContentType="application/zip"
    )

    # Upload/overwrite latest
    s3.put_object(
        Bucket=BUCKET,
        Key=latest_key,
        Body=zip_bytes,
        ContentType="application/zip"
    )

    return {
        "message": "SDK generated and uploaded",
        "restApiId": rest_api_id,
        "stage": stage_name,
        "sdkType": sdk_type,
        "versionedKey": versioned_key,
        "latestKey": latest_key
    }
