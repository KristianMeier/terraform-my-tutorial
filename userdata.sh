#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
sudo yum update -y
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
sudo yum update -y
sudo yum install git -y
# The 2 lines beneath was to do the "manual copy" of the react app.
cd /var/www/html
sudo git clone https://github.com/KristianMeier/cvr-for-aws-september-static.git .
#install node


# get react app, install it

# sudo systemctl restart httpd