#!/bin/bash

set -e

echo "🧹 Cleaning up agent container and image..."
docker rm -f azdo-agent || true
docker rmi azure-devops-agent:custom || true
rm -f Dockerfile start.sh
echo "✅ Cleanup complete."
