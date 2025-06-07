#!/bin/bash

set -e

echo "🔧 Installing Docker and dependencies..."

# Update packages
sudo apt update

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
  echo "📦 Installing Docker..."
  sudo apt install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
else
  echo "✅ Docker is already installed."
fi

# Configure Docker to use public DNS
echo "🌐 Configuring Docker DNS..."
sudo mkdir -p /etc/docker
sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
EOF'

# Restart Docker to apply DNS changes
echo "🔄 Restarting Docker..."
sudo systemctl restart docker

# Add current user to the docker group
if groups $USER | grep -q '\bdocker\b'; then
  echo "👤 User '$USER' is already in the docker group."
else
  echo "➕ Adding user '$USER' to docker group..."
  sudo usermod -aG docker $USER
  echo "⚠️ Please restart your shell or run 'newgrp docker' to apply group changes."
fi

echo "✅ Docker setup complete."