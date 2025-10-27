-------- active ---------------
aws apigateway update-stage \
  --rest-api-id a1b2c3d4 \
  --stage-name prod \
  --patch-operations op=replace,path=/canarySettings/deploymentId,value=abcd1234
---- confige ----------------
aws apigateway update-stage \
  --rest-api-id a1b2c3d4 \
  --stage-name prod \
  --patch-operations op=replace,path=/canarySettings/percentTraffic,value=5.0
