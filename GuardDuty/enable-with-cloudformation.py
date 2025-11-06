import json
import logging
import os
import urllib.request
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# اختیاری: با متغیرهای محیطی رفتار دیتاسورس‌ها را کنترل کن
ENABLE_S3_PROTECTION = os.getenv("ENABLE_S3_PROTECTION", "true").lower() == "true"
ENABLE_EKS_AUDIT_LOGS = os.getenv("ENABLE_EKS_AUDIT_LOGS", "true").lower() == "true"
ENABLE_MALWARE_PROT   = os.getenv("ENABLE_MALWARE_PROTECTION", "true").lower() == "true"
ENABLE_RDS_LOGIN      = os.getenv("ENABLE_RDS_LOGIN_AUDITING", "false").lower() == "true"  # فقط در ریجن‌های پشتیبانی‌شده

def send_response(event, context, status, data, physical_resource_id=None, reason=None):
    """ارسال پاسخ Custom Resource به CloudFormation (بدون cfnresponse)."""
    response_url = event['ResponseURL']

    response_body = {
        'Status': status,
        'Reason': reason or f"See CloudWatch Logs: {context.log_stream_name}",
        'PhysicalResourceId': physical_resource_id or context.log_stream_name,
        'StackId': event['StackId'],
        'RequestId': event['RequestId'],
        'LogicalResourceId': event['LogicalResourceId'],
        'Data': data or {}
    }

    json_response_body = json.dumps(response_body).encode("utf-8")
    req = urllib.request.Request(response_url, data=json_response_body, method="PUT")
    req.add_header('content-type', '')
    req.add_header('content-length', str(len(json_response_body)))

    try:
        with urllib.request.urlopen(req) as resp:
            logger.info("CloudFormation response status: %s", resp.status)
    except Exception as e:
        logger.error("Failed to send response to CloudFormation: %s", e)

def ensure_guardduty_enabled(region):
    """در ریجن داده‌شده GuardDuty را فعال یا آپدیت می‌کند و detector-id را برمی‌گرداند."""
    gd = boto3.client("guardduty", region_name=region)

    # 1) آیا دیتکتوری وجود دارد؟
    dets = gd.list_detectors().get("DetectorIds", [])
    detector_id = dets[0] if dets else None

    if not detector_id:
        # 2) ایجاد Detector با دیتاسورس‌های انتخابی
        params = {
            "Enable": True,
            "DataSources": {
                "S3Logs": {"Enable": ENABLE_S3_PROTECTION},
                "Kubernetes": {"AuditLogs": {"Enable": ENABLE_EKS_AUDIT_LOGS}},
                "MalwareProtection": {"ScanEc2InstanceWithFindings": {"EbsVolumes": ENABLE_MALWARE_PROT}},
            }
        }
        # RDS Login Auditing (در صورت نیاز/پشتیبانی)
        if ENABLE_RDS_LOGIN:
            params["DataSources"]["RDSLoginLogs"] = {"Enable": True}

        detector_id = gd.create_detector(**params)["DetectorId"]
        logger.info("GuardDuty detector created: %s", detector_id)
    else:
        # 3) اگر وجود داشت، مطمئن شو فعال است و دیتاسورس‌ها تنظیم‌اند
        details = gd.get_detector(DetectorId=detector_id)
        if not details.get("Status", "").lower() == "enabled":
            gd.update_detector(DetectorId=detector_id, Enable=True)
            logger.info("GuardDuty detector enabled: %s", detector_id)

        # آپدیت دیتاسورس‌ها (idempotent)
        try:
            gd.update_detector(
                DetectorId=detector_id,
                DataSources={
                    "S3Logs": {"Enable": ENABLE_S3_PROTECTION},
                    "Kubernetes": {"AuditLogs": {"Enable": ENABLE_EKS_AUDIT_LOGS}},
                    "MalwareProtection": {"ScanEc2InstanceWithFindings": {"EbsVolumes": ENABLE_MALWARE_PROT}},
                }
            )
            if ENABLE_RDS_LOGIN:
                gd.update_detector(
                    DetectorId=detector_id,
                    DataSources={"RDSLoginLogs": {"Enable": True}}
                )
        except ClientError as e:
            # بعضی فیچرها ممکن است در همه ریجن‌ها پشتیبانی نشوند؛ صرفاً لاگ کن
            logger.warning("Update data sources warning: %s", e)

    return detector_id

def handler(event, context):
    logger.info("Event: %s", json.dumps(event))
    region = os.environ.get("AWS_REGION")  # همان ریجن استک

    try:
        request_type = event['RequestType']

        # PhysicalResourceId ثابت/قابل‌تشخیص برای idempotency
        physical_id = f"GuardDuty-CustomResource-{region}"

        if request_type in ("Create", "Update"):
            detector_id = ensure_guardduty_enabled(region)
            data = {"DetectorId": detector_id, "Region": region, "Message": "GuardDuty enabled or already active."}
            send_response(event, context, "SUCCESS", data, physical_resource_id=physical_id)
        elif request_type == "Delete":
            # برای حذف استک، معمولاً GuardDuty را دست‌نخورده می‌گذاریم (Best Practice).
            data = {"Region": region, "Message": "No action on Delete (leaving GuardDuty as-is)."}
            send_response(event, context, "SUCCESS", data, physical_resource_id=physical_id)
        else:
            send_response(event, context, "FAILED", {"Message": "Unknown RequestType."}, physical_resource_id=physical_id)
    except Exception as e:
        logger.exception("Error enabling GuardDuty")
        send_response(event, context, "FAILED", {"Error": str(e)})
