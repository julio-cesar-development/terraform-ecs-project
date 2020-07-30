
terraform fmt -write=true -recursive

terraform refresh

terraform destroy -auto-approve

# log in SSH to EC2 machine
ssh -i ${AWS_SSH_KEY} ec2-user@$(terraform output ec2_instance_public_ip)
ssh -i ${AWS_SSH_KEY} ec2-user@$(terraform output ec2_instance_public_ip) -a "sudo docker logs -f ecs-agent"

# see logs of ECS agent on EC2 machine
docker logs -f ecs-agent

# get an AMI for ECS at some region
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux/recommended/image_id --region sa-east-1 --query "Parameters[0].Value"
