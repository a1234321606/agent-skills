# Jira API Templates

These templates are used by `index.sh` to construct `curl` commands.

## Variables
- `{{URL}}`: API base URL (includes `/rest/api/X`)
- `{{USER}}`: Username/Email
- `{{CREDENTIAL}}`: API Token/Password
- `{{KEY}}`: Issue Key (e.g., `PROJ-123`)
- `{{BODY}}`: JSON body for POST/PUT
- `{{QUERY}}`: JQL query string
- `{{TRANSITION_ID}}`: Transition ID

## Templates

### fetch_issue
`curl -s -u "{{USER}}:{{CREDENTIAL}}" -H "Content-Type: application/json" "{{URL}}/issue/{{KEY}}"`

### search_issues
`curl -s -G -u "{{USER}}:{{CREDENTIAL}}" --data-urlencode "jql={{QUERY}}" "{{URL}}/search/jql"`

### create_issue
`curl -s -X POST -u "{{USER}}:{{CREDENTIAL}}" -H "Content-Type: application/json" -d {{BODY}} "{{URL}}/issue"`

### add_comment
`curl -s -X POST -u "{{USER}}:{{CREDENTIAL}}" -H "Content-Type: application/json" -d {{BODY}} "{{URL}}/issue/{{KEY}}/comment"`

### transition_issue
`curl -s -X POST -u "{{USER}}:{{CREDENTIAL}}" -H "Content-Type: application/json" -d '{"transition": {"id": "{{TRANSITION_ID}}"}}' "{{URL}}/issue/{{KEY}}/transitions"`

### update_issue
`curl -s -X PUT -u "{{USER}}:{{CREDENTIAL}}" -H "Content-Type: application/json" -d {{BODY}} "{{URL}}/issue/{{KEY}}"`

### delete_issue
`curl -s -X DELETE -u "{{USER}}:{{CREDENTIAL}}" "{{URL}}/issue/{{KEY}}"`
