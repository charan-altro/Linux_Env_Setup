#!/bin/bash
set -e

MODE=${1:-docker} # docker or kind

if [[ "$MODE" == "docker" ]]; then
    docker run -d \
        --name azdo-agent \
        -e AZP_URL="https://dev.azure.com/YOUR_ORG/" \
        -e AZP_TOKEN="YOUR_PERSONAL_ACCESS_TOKEN" \
        -e AZP_POOL="YOUR_POOL" \
        -e AZP_AGENT_NAME="ubuntu-agent" \
        ubuntu-azdo-agent:latest
    echo "Agent running in Docker."
elif [[ "$MODE" == "kind" ]]; then
    # Assumes kind cluster is already running
    kubectl apply -f azdo-agent-deployment.yaml
    echo "Agent deployed to Kubernetes (kind)."
else
    echo "Unknown mode: $MODE"
    exit 1
fi