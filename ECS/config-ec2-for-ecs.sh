aws ecs create-cluster --cluster-name my-ecs-cluster
------- prepare instance(ubuntu)------------------
# role permission => AmazonEC2ContainerServiceforEC2Role
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

sudo mkdir -p /etc/ecs
echo "ECS_CLUSTER=my-ecs-cluster" | sudo tee /etc/ecs/ecs.config
sudo docker run --name ecs-agent --detach \
  --restart=always \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --volume=/var/log/ecs/:/log \
  --volume=/var/lib/ecs/data:/data \
  --volume=/etc/ecs:/etc/ecs \
  --net=host \
  --env-file=/etc/ecs/ecs.config \
  amazon/amazon-ecs-agent:latest

