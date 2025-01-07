#!/bin/bash
# Install docker https://docs.aws.amazon.com/pt_br/serverless-application-model/latest/developerguide/install-docker.html

set -e

sudo yum update -y 

sudo amazon-linux-extras install docker 

sudo yum install docker 

sudo service docker start 

sudo usermod -a -G docker ec2-user 

sudo docker run -d --name apache-server -p 80:80 httpd:latest