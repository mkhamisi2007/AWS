aws lambda update-function-configuration \
    --function-name MyLambdaFunction \
    --handler app.my_entry_point

------------------------------------
aws lambda get-function-configuration --function-name MyLambdaFunction --query "Handler"

------------------------------------
default =>  "lambda_function.lambda_handler"
