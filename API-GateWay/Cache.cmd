----------- enable cache ------------
aws apigateway update-stage \
  --rest-api-id a1b2c3d4 \
  --stage-name prod \
  --patch-operations op=replace,path=/cacheClusterEnabled,value=true

----------- for a methode ------------
  aws apigateway update-method \
  --rest-api-id a1b2c3d4 \
  --resource-id xyz123 \
  --http-method GET \
  --patch-operations op=replace,path=/cachingEnabled,value=true

---------------- change capacity --------------
  aws apigateway update-stage \
  --rest-api-id a1b2c3d4 \
  --stage-name prod \
  --patch-operations op=replace,path=/cacheClusterSize,value=1.6

--------------delete cache ---------------------
aws apigateway flush-stage-cache \
  --rest-api-id a1b2c3d4 \
  --stage-name prod

