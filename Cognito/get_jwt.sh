export CLIENT_ID="53o498lkiygfdhlq6olo4el85d1kcm"
export CLIENT_SECRET="1abfs2dbi4tgue1rcj_èjkhfddghtdjgu7lh7f94cgrri"
export USERNAME="mohammad.khamisi.etu@univ-lille.fr"
SECRET_HASH=$(printf "%s" "$USERNAME$CLIENT_ID" | openssl dgst -sha256 -hmac "$CLIENT_SECRET" -binary | base64)
echo "$SECRET_HASH"
-----
#-----in cognito => Sign in with username and password: ALLOW_USER_PASSWORD_AUTH
aws cognito-idp initiate-auth \
  --region us-east-1 \
  --client-id "$CLIENT_ID" \
  --auth-flow USER_PASSWORD_AUTH \
  --auth-parameters USERNAME="$USERNAME",PASSWORD='YourPasswordHere',SECRET_HASH="$SECRET_HASH"
---- out put a JWT---------------------
"IdToken": "eyJraWQiOiJteGptOHdOditxYkp1QjN.......
