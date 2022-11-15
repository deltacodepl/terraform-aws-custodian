#! /bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install unzip mc -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo apt-get install python3-dev python3.8-venv -y
sudo apt-get install python3-pip python3-wheel -y
sudo mkdir -p /home/ubuntu
cd /home/ubuntu
python3 -m venv custodian
source custodian/bin/activate
pip3 install c7n
pip3 install c7n-mailer
