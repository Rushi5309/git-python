
#!/usr/bin/env bash
set -euo pipefail

# Update package lists and install required packages
sudo apt-get update
sudo apt-get install -y ruby wget python3 python3-dev python3-pip python3-venv

# Clean up previous CodeDeploy installer
sudo rm -rf /home/ubuntu/install

# Download and install AWS CodeDeploy agent (ap-south-1)
cd /home/ubuntu
wget -q https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Enable and start CodeDeploy agent
sudo systemctl enable codedeploy-agent
sudo systemctl restart codedeploy-agent

# Upgrade virtualenv for the ubuntu user
python3 -m pip install --user --upgrade virtualenv

# Remove existing Django application
sudo rm -rf /home/ubuntu/django-aws_cicd

echo "CodeDeploy agent and Python prerequisites installed successfully."
