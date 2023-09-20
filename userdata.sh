#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
sudo yum update -y
sudo yum install git -y
cd /var/www/html
sudo git clone https://github.com/KristianMeier/cvr-for-aws-september-static.git .
# sudo systemctl restart httpd