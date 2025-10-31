aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name MyASG \
  --termination-policies "OldestInstance"
-------------------------------------------
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name MyASG \
  --termination-policies "OldestLaunchConfiguration" "ClosestToNextInstanceHour"
