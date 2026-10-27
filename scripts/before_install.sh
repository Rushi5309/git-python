
#!/usr/bin/env bash
set -Eeuo pipefail

LOG_FILE="/tmp/before_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

trap 'rc=$?; echo "ERROR: line ${BASH_LINENO[0]} failed (exit ${rc})"; exit "$rc"' ERR

echo "===== BeforeInstall started: $(date -Is) ====="

# Verify Ubuntu
cat /etc/os-release

# Install system prerequisites
echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ruby wget curl python3 python3-pip python3-venv python3-dev

# Install CodeDeploy agent if needed
if ! command -v codedeploy-agent >/dev/null 2>&1; then
    echo "Installing CodeDeploy agent..."
    cd /tmp
    wget -O install \
      https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
    chmod +x install
    sudo ./install auto
fi

# Start and verify the agent
sudo systemctl enable codedeploy-agent
sudo systemctl restart codedeploy-agent
sudo systemctl is-active codedeploy-agent

echo "===== BeforeInstall completed successfully ====="
