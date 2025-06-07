#!/bin/bash

set -e

echo "🔧 Installing Docker, kubectl, and kind..."

# Install Docker if not present
if ! command -v docker &> /dev/null; then
  echo "📦 Installing Docker..."
  sudo apt update
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

echo "🔄 Restarting Docker..."
sudo systemctl restart docker

# Add current user to the docker group
if ! groups $USER | grep -q '\bdocker\b'; then
  echo "➕ Adding user '$USER' to docker group..."
  sudo usermod -aG docker $USER
  echo "⚠️ Please restart your shell or run 'newgrp docker' to apply group changes."
else
  echo "👤 User '$USER' is already in the docker group."
fi

# Install kubectl if not present
if ! command -v kubectl &> /dev/null; then
  echo "📦 Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
else
  echo "✅ kubectl is already installed."
fi

# Install kind if not present
if ! command -v kind &> /dev/null; then
  echo "📦 Installing kind..."
  curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64"
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
else
  echo "✅ kind is already installed."
fi

echo "✅ Prerequisites for Docker and Kubernetes are installed."