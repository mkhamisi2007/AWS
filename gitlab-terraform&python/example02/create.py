import boto3
import os
import sys

# Fetching AWS credentials from environment variables
aws_access_key_id = os.getenv('----------')
aws_secret_access_key = os.getenv('--------------------')
aws_region = 'us-east-1' #os.getenv('us-east-1')

# Initialize boto3 ECS client
ecs_client = boto3.client('ecs', region_name=aws_region,
                          aws_access_key_id=aws_access_key_id,
                          aws_secret_access_key=aws_secret_access_key)

def create_task_definition(cluster_name, task_definition_name, container_name, docker_image):
    # Register ECS task definition
    response = ecs_client.register_task_definition(
        family=task_definition_name,
        networkMode='awsvpc',
        requiresCompatibilities=['FARGATE'],  # Specify Fargate compatibility
        cpu='512',  # 0.5 vCPU in CPU units (512 CPU units)
        memory='1024',  # 1 GB of RAM (1024 MB)
        containerDefinitions=[
            {
                'name': container_name,
                'image': docker_image,
                'cpu': 256,  # Customize as needed
                'memory': 512,  # Customize as needed
                'essential': True,
                'portMappings': [
                    {
                        'containerPort': 80,
                        'hostPort': 80
                    }
                ],
                 # Repository credentials for private Docker registry (Nexus)
                'repositoryCredentials': {
                        'credentialsParameter': f'arn:aws:secretsmanager:{aws_region}:277707094115:secret:docker-registry-credentials-znJQOW'  # Store credentials in Secrets Manager
                }

            }],
        executionRoleArn='arn:aws:iam::277707094115:role/ecsTaskExecutionRole' #,  # Adjust as needed
        #taskRoleArn='arn:aws:iam::your-account-id:role/ecsTaskRole'  # Adjust as needed
    )


    print("Task Definition Created:", response) 

def create_service(cluster_name, service_name, task_definition_name, desired_count):
    # Create ECS service
    response = ecs_client.create_service(
        cluster=cluster_name,
        serviceName=service_name,
        taskDefinition=task_definition_name,
        desiredCount=desired_count,
        launchType='FARGATE',  # Use EC2 if you're using EC2 launch type
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': ['subnet-0033cb5eecd9a7be9'],  # Modify with your subnet IDs
                'securityGroups': ['sg-09b65ef81d9502d8c'],  # Modify with your security group IDs
                'assignPublicIp': 'ENABLED'
            }
        })
#  ,
#         # If using Load Balancer
#         loadBalancers=[
#             {
#                 'targetGroupArn': 'arn:aws:elasticloadbalancing:region:your-account-id:targetgroup/your-target-group-name',
#                 'containerName': 'your-container-name',
#                 'containerPort': 80
#             }
#         ]
#     )

    print("Service Created:", response)

# Example Usage
docker_image = f"{sys.argv[1]}" # "your-nexus-server:8081/repository/your-repo/your-image:latest"  # Modify with the actual image URL
create_task_definition('my-docker-cluster', 'your-task-definition-name', 'your-container-name', docker_image)
create_service('my-docker-cluster', 'your-service-name', 'your-task-definition-name', 1)
