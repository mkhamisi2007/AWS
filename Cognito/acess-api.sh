-----get jwt token from cognito -------------------
aws cognito-idp initiate-auth --auth-flow USER_PASSWORD_AUTH --auth-parameters USERNAME=mohammad.khamisi.etu@univ-lille.fr,PASSWORD=****** --client-id 214709ppd1bs0futn89uhysdma
# "AccessToken": "eyJraWQiOiI...."
TOKEN='eyJraWQiOiIwd05qR...."
---- call api gateway(HTTP API) --------------
curl --request GET --header "Authorization: ${TOKEN}" https://8yungtq19c.execute-api.us-east-1.amazonaws.com
