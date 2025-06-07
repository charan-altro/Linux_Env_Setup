#!/bin/bash
set -e

MODE=${1:-docker}

if [[ "$MODE" == "docker" ]]; then
    docker rm -f azdo-agent || true
    docker rmi ubuntu-azdo-agent:latest || true
    echo "Docker agent cleaned up."
elif [[ "$MODE" == "kind" ]]; then
    kubectl delete -f azdo-agent-deployment.yaml || true
    echo "Kubernetes agent cleaned up."
else
    echo "Unknown mode: $MODE"
    exit 1
fi