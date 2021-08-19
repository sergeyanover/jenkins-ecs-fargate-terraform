#!/usr/bin/env bash

#sudo echo "Port 22" >> /etc/ssh/sshd_config
sudo echo "Port 12000" >> /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo yum update -y && sudo yum install -y docker && sudo yum install -y git
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

sudo yum install -y mc
sudo yum install -y screen
sudo yum install -y telnet
sudo yum install -y nmap

# install aws
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo mv /bin/aws /bin/aws1
sudo mv /usr/local/bin/aws /bin/aws
sudo ln -s /usr/local/aws-cli/v2/current/bin/aws_completer /bin/aws_completer
sudo rm awscliv2.zip

#install ecs-cli
sudo curl "https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest" -o "ecs-cli"
sudo chmod +x ecs-cli
sudo mv ecs-cli /bin/ecs-cli

# install aws efs utils
sudo yum install -y amazon-efs-utils

#install eksctl
sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz 
sudo mv eksctl /bin/eksctl

#install kubectl 1.21.2
sudo curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv kubectl /bin/kubectl

#install ansible
sudo amazon-linux-extras install epel
sudo yum install -y ansible 

#install terraform and packer
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform
sudo yum install -y packer

#install java
sudo amazon-linux-extras install -y java-openjdk11
#sudo yum install java-1.8.0-openjdk

