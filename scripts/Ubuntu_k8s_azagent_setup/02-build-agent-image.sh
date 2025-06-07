#!/bin/bash
set -e

# Build the Azure DevOps agent Docker image
docker build -t ubuntu-azdo-agent:latest .

echo "Azure DevOps agent Docker image built."