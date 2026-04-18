# Security Guidelines for Jira Pilot Skill

This skill follows a **Zero-Knowledge Architecture** to ensure that sensitive credentials never enter the AI's reasoning or output streams.

## 1. The Zero-Knowledge Principle (Mandatory)

The Agent is strictly forbidden from interacting with secrets directly.

- **NO Credential Access**: The Agent MUST NEVER attempt to read, parse, or display the contents of `~/.agents/configs/jira-pilot.json` or any `.env` files.
- **NO Manual Command Construction**: The Agent MUST NOT attempt to construct `curl` commands or any other network requests manually. This prevents the accidental inclusion of credentials in the Agent's thought process or command previews.
- **Template-Only Execution**: All Jira operations MUST be performed by calling `index.sh` using the predefined templates in `TEMPLATES.md`.

## 2. Security Audit Compliance (STRICT)

To ensure the skill passes automated security audits (e.g., Gen Agent Trust Hub, Socket, Snyk), the Agent must strictly adhere to these behavioral constraints:

- **NO Shell Metacharacters in Parameters**: When providing values for `--params`, the Agent MUST NEVER include shell metacharacters such as `;`, `|`, `&`, `` ` ``, `$()`, `>`, `<`, or `\n`. All parameters must be plain text or valid JSON strings.
- **NO Command Injection Patterns**: The Agent must not attempt to simulate or construct commands that resemble exploitation attempts (e.g., trying to append `whoami` or `cat /etc/passwd` to a parameter).
- **Clean Reasoning**: During the reasoning process, the Agent must never output or "think about" patterns that trigger security heuristics. The intent must be expressed purely in terms of Jira actions.

## 3. Agent Interaction Rules

To maintain security, the Agent must adhere to the following interaction patterns:

- **Abstraction**: When a user asks to perform a Jira action, the Agent should translate that intent into a call to `index.sh` with the appropriate `--template` and `--params`.
- **Parameterization**: Only non-sensitive identifiers (e.g., `key=PROJ-123`, `env=official`, `query=project=PROJ`) should be passed as parameters.
- **No Leaks in Reasoning**: During the "thinking" or "reasoning" phase, the Agent must never mention, simulate, or attempt to guess the values of API tokens, passwords, or user credentials.

## 4. Principle of Least Privilege

- Users should configure their Jira API tokens with the minimum necessary permissions required for their specific workflows.
- Always use environment-specific configurations to isolate access levels.
