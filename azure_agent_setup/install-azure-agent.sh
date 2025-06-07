#!/bin/bash
set -e

# --- Default configuration variables ---
AZP_URL="https://dev.azure.com/AzureDevops971/"     # Replace with your Azure DevOps organization URL
AZP_POOL="windowssubsystem"                         # Replace with your agent pool name
AZP_TOKEN="modify"                                  # Replace with your Azure DevOps PAT
AZP_AGENT_NAME="debian-docker-agent"                # Optional: customize agent name
IMAGE_NAME="azure-devops-agent:custom"
CONTAINER_NAME="azdo-agent"
KIND_CLUSTER_NAME="dev-cluster"
# ---------------------------------------

# 1. Install prerequisites (Ubuntu)
sudo apt-get update
sudo apt-get install -y curl jq tar

# 2. Create agent directory
sudo mkdir -p /opt/azagent
sudo chown $(whoami) /opt/azagent
cd /opt/azagent

# 3. Download latest agent package
AGENT_VERSION=$(curl -s https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | jq -r '.tag_name' | sed 's/v//')
AGENT_PKG="vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"
curl -LsO "https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/${AGENT_PKG}"

# 4. Extract agent
tar zxvf ${AGENT_PKG}
rm ${AGENT_PKG}

# 5. Prompt for config (use defaults, allow override)
read -e -p "Azure DevOps URL [${AZP_URL}]: " input_url
AZP_URL="${input_url:-$AZP_URL}"

read -e -p "Agent pool [${AZP_POOL}]: " input_pool
AZP_POOL="${input_pool:-$AZP_POOL}"

read -e -p "Agent name [${AZP_AGENT_NAME}]: " input_agent
AZP_AGENT_NAME="${input_agent:-$AZP_AGENT_NAME}"

read -e -s -p "Personal Access Token [${AZP_TOKEN}]: " input_token
echo
AZP_TOKEN="${input_token:-$AZP_TOKEN}"

# 6. Configure agent
./config.sh --unattended \
  --url "$AZP_URL" \
  --auth pat \
  --token "$AZP_TOKEN" \
  --pool "$AZP_POOL" \
  --agent "$AZP_AGENT_NAME" \
  --acceptTeeEula \
  --replace

# 7. Install as a service
sudo ./svc.sh install
sudo ./svc.sh start

echo "Azure DevOps agent installed and running as a service."
