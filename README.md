# Linux_Env_Setup
This repo used for setup all types of Linux distros using shell script and ansible playbook



# Azure DevOps Self-Hosted Agent Setup (Docker & Kubernetes/kind)

This repository provides scripts to build and run an Azure DevOps self-hosted agent using Docker or Kubernetes (kind) on WSL Debian.

---

## Prerequisites

- WSL2 with Debian
- Sudo privileges
- [Docker](https://docs.docker.com/engine/install/)
- [Azure DevOps Personal Access Token (PAT)](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

---

## Setup Steps

### 1. Install Prerequisites

```sh
bash scripts/Debian_setup/01-install-prerequisites.sh
```

> **Note:** If you are added to the `docker` group, restart your shell or run `newgrp docker`.

---

### 2. Build the Azure DevOps Agent Docker Image

```sh
bash scripts/Debian_setup/02-build-agent-image.sh
```

---

### 3. Run the Agent

#### **A. In Docker**

```sh
bash scripts/Debian_setup/03-run-agent-container.sh docker
```

#### **B. In Kubernetes (kind)**

```sh
bash scripts/Debian_setup/03-run-agent-container.sh kind
```

---

### 4. Reconfigure the Agent (Docker only)

```sh
bash scripts/Debian_setup/04-reconfigure-agent.sh
```

---

### 5. Cleanup

#### **A. Docker**

```sh
bash scripts/Debian_setup/05-cleanup.sh docker
```

#### **B. Kubernetes (kind)**

```sh
bash scripts/Debian_setup/05-cleanup.sh kind
```

---

## Debugging & Status

### **Docker**

- List containers:  
  `docker ps`
- View logs:  
  `docker logs azdo-agent`
- Enter container:  
  `docker exec -it azdo-agent bash`

### **Kubernetes (kind)**

- List pods:  
  `kubectl get pods`
- View pod logs:  
  `kubectl logs <pod-name>`
- Describe pod:  
  `kubectl describe pod <pod-name>`
- Enter pod:  
  `kubectl exec -it <pod-name> -- bash`

---

## Configuration

Edit these variables in `03-run-agent-container.sh` before running:

```sh
AZP_URL="https://dev.azure.com/YOUR_ORG/"
AZP_POOL="YOUR_POOL"
AZP_TOKEN="YOUR_PERSONAL_ACCESS_TOKEN"
AZP_AGENT_NAME="your-agent-name"
```

---

## Notes

- For Kubernetes, you can scale agents by editing the `replicas` field in `azdo-agent-deployment.yaml`.
- For security, consider using Kubernetes secrets for `AZP_TOKEN` in production.

---

## References

- [Azure DevOps Agents Documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/)
- [kind (Kubernetes IN Docker)](https://kind.sigs.k8s.io/)
- [Docker Documentation](https://docs.docker.com/)

---