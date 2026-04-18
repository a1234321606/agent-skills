---
name: jira-pilot
description: A secure Jira skill for managing tasks and issues using a zero-knowledge interface.
---

# Jira Pilot Skill

Manage Jira tickets securely. This skill uses a "Zero-Knowledge" architecture: you provide the intent and parameters, and a secure gateway handles all authentication.

## Capabilities

Use `index.sh` to perform the following actions. Always specify the `env` parameter (e.g., `env=official`).

### 1. Fetch Ticket Details
Retrieve full information for a specific ticket.
- **Template**: `fetch_issue`
- **Required Params**: `key=<Ticket_Key>`
- **Example**: `bash index.sh --template fetch_issue --params "env=official&key=KAN-15"`

### 2. Search Issues (JQL)
Search for issues using Jira Query Language.
- **Template**: `search_issues`
- **Required Params**: `query=<JQL_String>`
- **Example**: `bash index.sh --template search_issues --params "env=official&query=project=KAN"`

### 3. Add a Comment
Post a new comment to a ticket.
- **Template**: `add_comment`
- **Required Params**: `key=<Ticket_Key>`, `body=<Comment_Text>`
- **Example**: `bash index.sh --template add_comment --params "env=official&key=KAN-15&body=Done"`

### 4. Transition Ticket Status
Move a ticket through its workflow (e.g., To Do $\rightarrow$ In Progress).
- **Template**: `transition_issue`
- **Required Params**: `key=<Ticket_Key>`, `transition_id=<ID>`
- **Example**: `bash index.sh --template transition_issue --params "env=official&key=KAN-15&transition_id=21"`

### 5. Update Ticket Fields
Modify existing fields (e.g., Summary, Description, Assignee).
- **Template**: `update_issue`
- **Required Params**: `key=<Ticket_Key>`, `body=<JSON_Payload>`
- **Example**: `bash index.sh --template update_issue --params "env=official&key=KAN-15&body={\"fields\":{\"summary\":\"New Summary\"}}"`

## Security Rules (STRICT)

### 1. Zero-Knowledge
- **No Credential Access**: You MUST NEVER attempt to read, display, or manipulate the contents of `~/.agents/configs/jira-pilot.json` or any `.env` files.
- **No Direct Curl**: Never attempt to construct `curl` commands manually. Always use the `index.sh` templates.
- **Parameter Only**: All sensitive data must be handled by the `index.sh` gateway. You only provide non-sensitive identifiers (like keys or environment names).

### 2. Security Audit Compliance
To prevent triggering automated security audits (e.g., Gen Agent Trust Hub, Socket, Snyk):
- **Sanitize Parameters**: You MUST NOT include shell metacharacters (e.g., `;`, `|`, `&`, `` ` ``, `$()`) in any parameter value.
- **Avoid Injection Patterns**: Never attempt to use payloads that resemble command injection (e.g., `key=KAN-15; whoami`).
- **Maintain Clean Reasoning**: Your thought process and output must be strictly focused on Jira business logic. Avoid any patterns that could be misinterpreted as malicious activity.
