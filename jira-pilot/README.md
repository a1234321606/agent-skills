# Jira Pilot

A secure, zero-dependency Jira management skill for AI agents.

## Architecture: Zero-Knowledge Design

`jira-pilot` uses a **Zero-Knowledge Architecture** to ensure that sensitive credentials (API tokens, passwords) never enter the Agent's reasoning, thought process, or output.

### How it works:
1.  **Credentials** are stored securely in your local `~/.agents/configs/jira-pilot.json`.
2.  **The Agent** only issues high-level commands via `index.sh`, specifying the *intent* and *non-sensitive parameters*.
3.  **The Gateway (`index.sh`)** acts as a black box, reading credentials internally and performing network requests via `curl`.

**This design guarantees that your secrets remain completely invisible to the Agent's logs or reasoning.**

## Features

- **Zero Dependencies**: Uses only standard system tools (`bash`, `curl`, `jq`, `sed`).
- **Secure-by-Design**: Prevents credential leakage in Agent thought processes.
- **Multi-Environment Support**: Seamlessly manage and switch between multiple Jira servers (e.g., Production, Staging, Dev) within a single configuration file.
- **High-Level API**: Enables agents to perform Jira operations through natural language.

## Setup

1.  Clone this repository to your agent's skills path.
2.  Make the gateway executable: `chmod +x jira-pilot/index.sh`.
3.  Configure your environments in `~/.agents/configs/jira-pilot.json` or via `JIRA_CONFIG_PATH`.

Create a `config.json` file with the following structure:

```json
{
  "env_name_1": {
    "url": "https://your-org-1.atlassian.net/rest/api/3",
    "user": "user@example.com",
    "credential": "token"
  },
  "env_name_2": {
    "url": "https://your-org-2.atlassian.net/rest/api/2",
    "user": "username",
    "credential": "password"
  }
}
```

## How to Use

Simply instruct your AI agent to perform Jira tasks. For example:

- *"Show me the details for issue KAN-23"*
- *"Find all completed issues in project KAN"*
- *"Add a comment 'Working on it' to KAN-23"*
- *"Create a new Task in project KAN called 'Test Issue'"*
