
#!/usr/bin/env bash
set -Eeuo pipefail

# Update package lists and install required packages
sudo apt-get update
sudo apt-get install -y \
    ruby \
    wget \
    curl \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv

# Navigate to the Ubuntu home directory
cd /home/ubuntu

# Remove previous CodeDeploy installer
sudo rm -f /home/ubuntu/install

# Download AWS CodeDeploy agent for ap-south-1
wget -q \
    https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install \
    -O /home/ubuntu/install

chmod +x /home/ubuntu/install

# Install CodeDeploy agent
sudo /home/ubuntu/install auto

# Enable and start CodeDeploy agent
sudo systemctl enable codedeploy-agent
sudo systemctl restart codedeploy-agent

# Verify CodeDeploy agent status
sudo systemctl --no-pager status codedeploy-agent

# Upgrade pip for the Ubuntu user's Python environment
sudo -u ubuntu python3 -m pip install --user --upgrade pip

# Remove the old Django application directory if it exists
if [ -d /home/ubuntu/django-aws_cicd ]; then
    sudo rm -rf /home/ubuntu/django-aws_cicd
fi

# Set ownership of the home directory
sudo chown ubuntu:ubuntu /home/ubuntu

echo "CodeDeploy agent and Python prerequisites installed successfully."

