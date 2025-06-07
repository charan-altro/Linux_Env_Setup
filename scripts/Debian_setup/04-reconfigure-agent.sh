#!/bin/bash

set -e

CONTAINER_NAME="azdo-agent"

if [ -z "$AZP_TOKEN" ]; then
  echo "❌ AZP_TOKEN environment variable is not set."
  exit 1
fi

echo "🔁 Reconfiguring Azure DevOps agent..."

# Check if agent directory exists before proceeding
if ! docker exec $CONTAINER_NAME bash -c 'test -d agent'; then
  echo "❌ 'agent' directory not found in container. Make sure the container has started and downloaded the agent."
  exit 1
fi

docker exec -it $CONTAINER_NAME bash -c "cd agent && ./config.sh remove --unattended --auth pat --token \"$AZP_TOKEN\""
docker restart $CONTAINER_NAME
echo "✅ Agent reconfigured and restarted."