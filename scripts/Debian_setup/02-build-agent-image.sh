#!/bin/bash

set -e

IMAGE_NAME="azure-devops-agent:custom"
AGENT_VERSION="4.255.0"
AGENT_URL="https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"

echo "📦 Building Azure DevOps agent Docker image..."

cat <<EOF > Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf

RUN apt-get update && \
    apt-get install -y curl jq git sudo libcurl4-openssl-dev libicu-dev libkrb5-dev libssl-dev unzip && \
    apt-get clean

WORKDIR /azp

COPY start.sh .

RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
EOF

cat <<EOF > start.sh
#!/bin/bash
set -e

if [ -z "\$AZP_URL" ] || [ -z "\$AZP_TOKEN" ] || [ -z "\$AZP_POOL" ]; then
  echo "One or more required environment variables are missing: AZP_URL, AZP_TOKEN, AZP_POOL"
  exit 1
fi

export AGENT_ALLOW_RUNASROOT=1

if [ ! -d "./agent" ]; then
  echo "Downloading Azure Pipelines agent..."
  mkdir agent
  cd agent
  curl -LsS ${AGENT_URL} | tar -xz
  cd ..
fi

cd agent

./config.sh --unattended \\
  --url "\$AZP_URL" \\
  --auth pat \\
  --token "\$AZP_TOKEN" \\
  --pool "\$AZP_POOL" \\
  --agent "\${AZP_AGENT_NAME:-\$(hostname)}" \\
  --acceptTeeEula \\
  --replace

./svc.sh install
./svc.sh start

tail -f /dev/null
EOF

chmod +x start.sh

docker build -t $IMAGE_NAME .
echo "✅ Docker image built: $IMAGE_NAME"