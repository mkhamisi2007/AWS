aws codeartifact login --tool pip --repository pypi-store --domain my-domain --domain-owner 277707094158 --region us-east-1

--------------------------add layers in lambda  -------------------------
REGION=us-east-1
DOMAIN=my-domain
REPO=pypi-store
TOKEN=$(aws codeartifact get-authorization-token \
  --domain $DOMAIN --region $REGION \
  --query authorizationToken --output text)
ENDPOINT=$(aws codeartifact get-repository-endpoint \
  --domain $DOMAIN --repository $REPO --format pypi \
  --region $REGION --query repositoryEndpoint --output text)
HOST=${ENDPOINT#https://}
INDEX_URL="https://aws:${TOKEN}@${HOST}simple/"
pip install --index-url "$INDEX_URL" -t python/ mangum asyncpg python-dotenv
zip -r layer-fastapi-ca.zip python
aws lambda publish-layer-version   --layer-name fastapi-deps-from-codeartifact   --zip-file fileb://layer-fastapi-ca.zip   --compatible-runtimes python3.12   --region $REGION
