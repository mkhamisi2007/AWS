aws ecs create-cluster --cluster-name my-ecs-cluster
------- prepare instance(ubuntu)------------------
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
