#!/bin/bash

# index.sh - Zero-Knowledge Jira CLI Wrapper

DEFAULT_CONFIG="$HOME/.agents/configs/jira-pilot.json"
TEMPLATES_FILE="$(dirname "$0")/TEMPLATES.md"

usage() {
    echo "Usage: $0 --template <template_name> --params \"key=VAL&param2=VAL2\""
    echo "       --config <path> (Optional)"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --template) TEMPLATE_NAME="$2"; shift ;;
        --params) PARAMS_STR="$2"; shift ;;
        --config) CONFIG_PATH="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

if [[ -z "$TEMPLATE_NAME" || -z "$PARAMS_STR" ]]; then
    usage
fi

# 1. Load Config
if [[ -n "$CONFIG_PATH" ]]; then
    if [[ ! -f "$CONFIG_PATH" ]]; then
        echo "Error: Config file not found at $CONFIG_PATH"
        exit 1
    fi
elif [[ -f "$DEFAULT_CONFIG" ]]; then
    CONFIG_PATH="$DEFAULT_CONFIG"
else
    echo "Error: Configuration file not found."
    echo "Please set JIRA_CONFIG_PATH environment variable, or place config at $DEFAULT_CONFIG"
    exit 1
fi

ENV="official"
for pair in $(echo "$PARAMS_STR" | tr '&' ' '); do
    key="${pair%%=*}"
    key_lower=$(echo "$key" | tr '[:upper:]' '[:lower:]')
    if [[ $key_lower == env ]]; then
        ENV="${pair#*=}"
    fi
done

URL=$(jq -r ".${ENV}.url" "$CONFIG_PATH")
USER=$(jq -r ".${ENV}.user // .${ENV}.username" "$CONFIG_PATH")
CREDENTIAL=$(jq -r ".${ENV}.credential // .${ENV}.password" "$CONFIG_PATH")

export JIRA_URL="$URL"
export JIRA_USER="$USER"
export JIRA_CREDENTIAL="$CREDENTIAL"

if [[ "$URL" == "null" || "$USER" == "null" ]]; then
    echo "Error: Environment '$ENV' not found or incomplete in config."
    exit 1
fi

# 2. Find Template
CMD_TEMPLATE=$(awk "/### $TEMPLATE_NAME/ {getline; print \$0}" "$TEMPLATES_FILE" | sed 's/^`//;s/`$//')

if [[ -z "$CMD_TEMPLATE" ]]; then
    echo "Error: Template '$TEMPLATE_NAME' not found or command not found in $TEMPLATES_FILE"
    exit 1
fi

# 3. Prepare Parameters
FINAL_CMD="$CMD_TEMPLATE"

# Replace placeholders with environment variable names
FINAL_CMD="${FINAL_CMD//\{\{URL\}\}/\$JIRA_URL}"
FINAL_CMD="${FINAL_CMD//\{\{USER\}\}/\$JIRA_USER}"
FINAL_CMD="${FINAL_CMD//\{\{CREDENTIAL\}\}/\$JIRA_CREDENTIAL}"

# Replace User Parameters
IFS='&' read -ra ADDR <<< "$PARAMS_STR"
for i in "${ADDR[@]}"; do
    key="${i%%=*}"
    key_upper=$(echo "$key" | tr '[:lower:]' '[:upper:]')
    val="${i#*=}"
    # Use printf %q to escape the value for safe shell expansion
    ESCAPED_VAL=$(printf '%q' "$val")
    FINAL_CMD="${FINAL_CMD//\{\{$key_upper\}\}/$ESCAPED_VAL}"
done

# Check if any placeholders remain
if [[ "$FINAL_CMD" == *"{{"* ]]; then
    echo "Error: Missing parameters for template '$TEMPLATE_NAME'. Remaining: $FINAL_CMD"
    exit 1
fi

# 4. Execute
eval $FINAL_CMD
