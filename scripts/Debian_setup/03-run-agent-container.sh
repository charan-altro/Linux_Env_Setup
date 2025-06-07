#!/bin/bash

set -e

# === Required Configuration ===
AZP_URL="https://dev.azure.com/AzureDevops971/"     # Replace this
AZP_POOL="windowssubsystem"                           # Replace if needed
AZP_TOKEN="modify"                         # Replace this
AZP_AGENT_NAME="debian-docker-agent"         # Optional
IMAGE_NAME="azure-devops-agent:custom"
CONTAINER_NAME="azdo-agent"

# Remove existing container if exists
docker rm -f $CONTAINER_NAME 2>/dev/null || true

# Run agent container
echo "🚀 Starting Azure DevOps agent container..."
docker run -d \
  --name $CONTAINER_NAME \
  -e AZP_URL="$AZP_URL" \
  -e AZP_TOKEN="$AZP_TOKEN" \
  -e AZP_POOL="$AZP_POOL" \
  -e AZP_AGENT_NAME="$AZP_AGENT_NAME" \
  --restart always \
  $IMAGE_NAME

echo "✅ Agent container '$CONTAINER_NAME' is running."
