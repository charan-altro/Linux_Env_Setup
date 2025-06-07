#!/bin/bash

set -e

CONTAINER_NAME="azdo-agent"
IMAGE_NAME="azure-devops-agent:custom"

echo "🧹 Cleaning up agent container and image..."

# Remove container if exists
docker rm -f $CONTAINER_NAME 2>/dev/null || true

# Remove image if exists
docker rmi $IMAGE_NAME 2>/dev/null || true

# Remove generated files
rm -f Dockerfile start.sh

echo "✅ Cleanup complete."