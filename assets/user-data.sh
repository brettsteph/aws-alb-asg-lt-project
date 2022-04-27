#!/bin/bash
yum update -y
yum install -y httpd
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
aws s3 cp s3://ec2-with-static-site --region us-east-1 /var/www/html/ --recursive
systemctl start httpd
systemctl enable httpd