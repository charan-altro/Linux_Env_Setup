#!/bin/bash

set -e

echo "🔧 Installing Docker and dependencies..."

# Update packages
sudo apt update

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  sudo apt install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
else
  echo "✅ Docker is already installed."
fi

# Allow current user to run docker without sudo
sudo usermod -aG docker $USER
echo "✅ Docker is ready. You may need to restart your shell."
