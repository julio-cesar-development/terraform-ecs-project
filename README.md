# Terraform Project to provide infrastructure at AWS using ECS

* Instructions

> Create a SSH key in the machine (recommended name: key_aws), add the private and public keys in this directory
> Change the file terraform.tfvars.example to terraform.tfvars and add the correct variables of your configuration

* Commands

```bash
# log in SSH to EC2 machine
ssh -i ${AWS_PRIVATE_KEY} ec2-user@$(terraform output ec2_instance_public_ip)

# see logs of ECS agent on EC2 machine
docker logs -f ecs-agent

# get an AMI for ECS at some region
aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux/recommended/image_id --region sa-east-1 --query "Parameters[0].Value"

# run terraform
terraform init
terraform plan
terraform apply -auto-approve

# some docs
https://aws.amazon.com/pt/premiumsupport/knowledge-center/launch-ecs-optimized-ami/
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
```
