
terraform fmt -write=true -recursive

terraform refresh
terraform show

terraform destroy -auto-approve

# log in SSH to EC2 machine
ssh -i ${AWS_SSH_KEY} ec2-user@${INSTANCE_IP}
ssh -i ${AWS_SSH_KEY} ec2-user@${INSTANCE_IP} -a "sudo docker logs -f ecs-agent"

# see logs of ECS agent on EC2 machine
docker logs -f ecs-agent

# get an AMI for ECS at some region
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux/recommended/image_id --region sa-east-1 --query "Parameters[0].Value"
