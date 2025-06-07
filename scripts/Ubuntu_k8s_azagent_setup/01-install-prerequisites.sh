#!/bin/bash
set -e

# Update and install required packages
sudo apt-get update
sudo apt-get install -y \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    docker.io \
    kubectl

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Prerequisites installed."