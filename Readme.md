# install

- terraform init
- terramform apply

# run

- terraform state show aws_instance.dev_node
- copy public_ip
- go to http://public_ip

# Togo

- Make git private and ssh. It's public now.
- Brug Terraform CLoud

# Structure

-Organize by Functionality/Component:

- networking.tf: Contains VPC, subnets, NAT gateways, etc.
- compute.tf: Contains EC2 instances, autoscaling groups, etc.
- storage.tf: Contains S3 buckets, EBS volumes, etc.
