# Azure DevOps Self-Hosted Agent (Simple Install)

This folder provides a script to install the Azure DevOps agent directly on a Linux machine (no Docker/Kubernetes).

## Usage

```sh
bash install-azure-agent.sh
```

You will be prompted for:
- Azure DevOps organization URL
- Agent pool name
- Agent name
- Personal Access Token (PAT)

The agent will be installed to `/opt/azagent` and run as a system service.

## Prerequisites

- Ubuntu/Debian-based Linux
- Sudo privileges
- [Personal Access Token (PAT)](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

## References

- [Azure Pipelines Agent Docs](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux)
