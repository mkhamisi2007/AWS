Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
--------------------------
choco install eksctl -y
eksctl version
eksctl get clusters
---------------------------
eksctl create cluster \
  --name test-cluster \
  --version 1.17 \
  --region eu-central-1 \
  --nodegroup-name linux-nodes \
  --node-type t2.micro \
  --nodes 2

