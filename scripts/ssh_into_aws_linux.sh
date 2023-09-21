DEV_IP=$(terraform output dev_ip | tr -d '"') \
ssh -i ~/.ssh/mtckey ec2-user@$DEV_IP