#!/bin/bash
 
sudo apt update -y

sudo apt upgrade -y 

sudo apt install -y docker.io


## install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo apt install unzip 
unzip awscliv2.zip 
sudo ./aws/install

#check the version

aws --version

echo "Waiting for 15 seconds before installing the eksctl"
sleep 15

# installation of git on the EC2 instance

sudo apt install git -y

# install Terraform on Ubuntu 22.04|20.04 |18.04

sudo apt-get update
sudo apt install  software-properties-common gnupg2 curl
#hwe-support-status --verbose
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/

sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt install terraform -y


echo "Waiting for 29 seconds before installing the aws cli..."
sleep 15

# install kubectl on the EC2 instance

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
kubectl version

echo "Waiting for 30 seconds before installing the aws cli..."
sleep 15

# Add the current user to the 'docker' group 
sudo chmod 777 /var/run/docker.sock

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Print Docker version
docker --version

echo "Waiting for 15 seconds before installing the aws cli..."
sleep 15

sudo apt install openjdk-17-jre -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y 
sudo apt-get install jenkins -y


