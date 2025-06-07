#!/bin/bash

set -e

IMAGE_NAME="azure-devops-agent:custom"

echo "📦 Building Azure DevOps agent Docker image..."

# Create Dockerfile if not exists
cat <<EOF > Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl jq git sudo libcurl4-openssl-dev libicu-dev libkrb5-dev libssl-dev unzip && \
    apt-get clean

WORKDIR /azp

COPY start.sh .

RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
EOF

# Create startup script
cat <<'EOF' > start.sh
#!/bin/bash
set -e

if [ -z "$AZP_URL" ] || [ -z "$AZP_TOKEN" ] || [ -z "$AZP_POOL" ]; then
  echo "One or more required environment variables are missing: AZP_URL, AZP_TOKEN, AZP_POOL"
  exit 1
fi

export AGENT_ALLOW_RUNASROOT=1

if [ ! -d "./agent" ]; then
  echo "Downloading Azure Pipelines agent..."
  curl -LsS https://vstsagentpackage.azureedge.net/agent/3.236.0/vsts-agent-linux-x64-3.236.0.tar.gz | tar -xz
  mv vsts-agent-linux-x64-3.236.0 agent
fi

cd agent

./config.sh --unattended \
  --url "$AZP_URL" \
  --auth pat \
  --token "$AZP_TOKEN" \
  --pool "$AZP_POOL" \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --acceptTeeEula \
  --replace

./svc.sh install
./svc.sh start

tail -f /dev/null
EOF

# Build Docker image
docker build -t $IMAGE_NAME .
echo "✅ Docker image built: $IMAGE_NAME"
