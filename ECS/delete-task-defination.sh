for td in $(aws ecs list-task-definitions --family-prefix my-task --query 'taskDefinitionArns[]' --output text); do
  aws ecs deregister-task-definition --task-definition "$td"
done
