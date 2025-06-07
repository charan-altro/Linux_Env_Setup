#!/bin/bash

set -e

# === Required Configuration ===
AZP_URL="https://dev.azure.com/AzureDevops971/"     # Replace with your Azure DevOps organization URL
AZP_POOL="windowssubsystem"                         # Replace with your agent pool name
AZP_TOKEN="modify"                                  # Replace with your Azure DevOps PAT
AZP_AGENT_NAME="debian-docker-agent"                # Optional: customize agent name
IMAGE_NAME="azure-devops-agent:custom"
CONTAINER_NAME="azdo-agent"
KIND_CLUSTER_NAME="dev-cluster"

MODE="${1:-docker}" # Pass "kind" as first argument to deploy to kind

# Validate required variables
if [[ -z "$AZP_URL" || -z "$AZP_POOL" || -z "$AZP_TOKEN" ]]; then
  echo "❌ AZP_URL, AZP_POOL, and AZP_TOKEN must be set."
  exit 1
fi

if [[ "$MODE" == "docker" ]]; then
  # Remove existing container if exists
  docker rm -f $CONTAINER_NAME 2>/dev/null || true

  # Run agent container
  echo "🚀 Starting Azure DevOps agent container (Docker)..."
  docker run -d \
    --name $CONTAINER_NAME \
    -e AZP_URL="$AZP_URL" \
    -e AZP_TOKEN="$AZP_TOKEN" \
    -e AZP_POOL="$AZP_POOL" \
    -e AZP_AGENT_NAME="$AZP_AGENT_NAME" \
    --restart always \
    $IMAGE_NAME

  echo "✅ Agent container '$CONTAINER_NAME' is running."
elif [[ "$MODE" == "kind" ]]; then
  # Create kind cluster if not exists
  if ! kind get clusters | grep -q "^${KIND_CLUSTER_NAME}\$"; then
    echo "⎈ Creating kind cluster '$KIND_CLUSTER_NAME'..."
    kind create cluster --name $KIND_CLUSTER_NAME
  else
    echo "✅ kind cluster '$KIND_CLUSTER_NAME' already exists."
  fi

  # Load image into kind
  echo "📦 Loading image into kind cluster..."
  kind load docker-image $IMAGE_NAME --name $KIND_CLUSTER_NAME

  # Deploy agent to Kubernetes
  echo "⎈ Deploying Azure DevOps agent to Kubernetes..."

  cat <<EOF > azdo-agent-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azdo-agent
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azdo-agent
  template:
    metadata:
      labels:
        app: azdo-agent
    spec:
      containers:
      - name: azdo-agent
        image: $IMAGE_NAME
        env:
        - name: AZP_URL
          value: "$AZP_URL"
        - name: AZP_TOKEN
          value: "$AZP_TOKEN"
        - name: AZP_POOL
          value: "$AZP_POOL"
        - name: AZP_AGENT_NAME
          value: "$AZP_AGENT_NAME"
EOF

  kubectl apply -f azdo-agent-deployment.yaml

  echo "✅ Azure DevOps agent deployed to kind cluster!"
  echo "ℹ️  Check pod status with: kubectl get pods"
  echo "ℹ️  View logs with: kubectl logs deployment/azdo-agent"
else
  echo "❌ Unknown mode: $MODE. Use 'docker' or 'kind'."
  exit 1
fi