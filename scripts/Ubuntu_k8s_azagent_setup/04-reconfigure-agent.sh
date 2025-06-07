#!/bin/bash
set -e

# For Docker: Remove and re-run the agent container
docker rm -f azdo-agent || true
bash ./03-run-agent-container.sh docker

echo "Agent reconfigured."