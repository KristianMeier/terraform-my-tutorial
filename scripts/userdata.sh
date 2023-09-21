#!/bin/bash
sudo yum update -y
yum update -y
#Install Apache
yum install -y httpd
systemctl start httpd
systemctl enable httpd
# Install Git
sudo yum install git -y
# Install Node.js 16.x LTS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16.0.0
# Deploy React App
cd /home/ec2-user
mkdir "React App"
cd "React App"
git clone https://github.com/KristianMeier/cvr-for-aws-september.git .
npm i
npm run build
sudo cp -r build/* /var/www/html/
# Copy 