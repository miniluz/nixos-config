#!/usr/bin/env bash

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: bg-run <command> [arguments...]"
    echo "Example: bg-run obsidian"
    exit 1
fi

# Run the command in background and detach it
"$@" >/dev/null 2>&1 & disown