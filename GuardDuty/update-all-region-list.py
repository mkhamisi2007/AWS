BUCKET_URL="https://s3.amazonaws.com/my-bucket/threat-ips.txt"
IPSET_NAME="OrgThreatIPs"

# همه Regionها (در صورت نیاز محدودش کن)
for R in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); do
  echo "== $R =="

  DET=$(aws guardduty list-detectors --region $R --query 'DetectorIds[0]' --output text)

  # آیا IP set از قبل وجود دارد؟
  IPSET_ID=$(aws guardduty list-ip-sets --region $R --detector-id $DET \
              --query 'IpSetIds[0]' --output text 2>/dev/null)

  if [ "$IPSET_ID" = "None" ] || [ -z "$IPSET_ID" ]; then
    aws guardduty create-ip-set \
      --region $R \
      --detector-id $DET \
      --name "$IPSET_NAME" \
      --format TXT \
      --location "$BUCKET_URL" \
      --activate
  else
    aws guardduty update-ip-set \
      --region $R \
      --detector-id $DET \
      --ip-set-id $IPSET_ID \
      --location "$BUCKET_URL" \
      --activate
  fi
done
