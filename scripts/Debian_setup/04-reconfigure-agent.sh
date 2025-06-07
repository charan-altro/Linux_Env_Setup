#!/bin/bash

set -e

CONTAINER_NAME="azdo-agent"

echo "🔁 Reconfiguring Azure DevOps agent..."
docker exec -it $CONTAINER_NAME ./agent/config.sh remove --unattended --auth pat --token "$AZP_TOKEN"
docker restart $CONTAINER_NAME
echo "✅ Agent reconfigured and restarted."
