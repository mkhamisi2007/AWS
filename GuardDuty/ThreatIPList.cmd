aws guardduty list-detectors
# Detector is i engin for every region beacuse every region have own dectector and we shoud apply list ip for every detector
aws guardduty create-ip-set \
  --detector-id <detector-id> \
  --name "ThreatIPList" \
  --format TXT \
  --location "https://s3.amazonaws.com/my-bucket/threat-ips.txt" \
  --activate
