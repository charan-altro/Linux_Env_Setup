#!/bin/bash

set -e

CONTAINER_NAME="azdo-agent"
IMAGE_NAME="azure-devops-agent:custom"
KIND_CLUSTER_NAME="dev-cluster"

MODE="${1:-docker}" # Pass "kind" as first argument to clean up kind

echo "🧹 Cleaning up agent container/image and/or kind cluster..."

if [[ "$MODE" == "docker" ]]; then
  # Remove container if exists
  docker rm -f $CONTAINER_NAME 2>/dev/null || true

  # Remove image if exists
  docker rmi $IMAGE_NAME 2>/dev/null || true

  # Remove generated files
  rm -f Dockerfile start.sh

  echo "✅ Docker cleanup complete."
elif [[ "$MODE" == "kind" ]]; then
  kubectl delete deployment azdo-agent 2>/dev/null || true
  kind delete cluster --name $KIND_CLUSTER_NAME 2>/dev/null || true
  rm -f azdo-agent-deployment.yaml Dockerfile start.sh
  echo "✅ kind/Kubernetes cleanup complete."
else
  echo "❌ Unknown mode: $MODE. Use 'docker' or 'kind'."
  exit 1
fi