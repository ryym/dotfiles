#!/bin/bash

# A script to build a simple Claude Code statusline like below.
# [Sonnet 4.5] $0.09 | 24495.0s | 1731 tokens

# Read JSON input from stdin.
context=$(cat)

# Extract values from JSON.
model=$(echo "$context" | jq -r '.model.display_name')
cost=$(echo "$context" | jq -r '.cost.total_cost_usd')
duration=$(echo "$context" | jq -r '.cost.total_duration_ms')
tokens=$(echo "$context" | jq -r '.context_window.total_input_tokens')

# Format values.
cost_formatted=$(awk "BEGIN {printf \"%.2f\", int($cost * 100 + 1) / 100}")
duration_sec=$(awk "BEGIN {printf \"%.1f\", $duration / 1000}")

# Format output.
echo "[$model] \$${cost_formatted} | ${duration_sec}s | ${tokens} tokens"

# As a reference, context information Claude Code provides looks like below (as of 2026-01):
# {
#   "session_id": "<session-id>",
#   "transcript_path": "/home/ryu/.claude/projects/-home-ryu--dotfiles/<session-id>.jsonl",
#   "cwd": "/home/ryu/.dotfiles",
#   "model": {
#     "id": "claude-sonnet-4-5-20250929",
#     "display_name": "Sonnet 4.5"
#   },
#   "workspace": {
#     "current_dir": "/home/ryu/.dotfiles",
#     "project_dir": "/home/ryu/.dotfiles"
#   },
#   "version": "2.0.76",
#   "output_style": {
#     "name": "default"
#   },
#   "cost": {
#     "total_cost_usd": 0.15047480000000002,
#     "total_duration_ms": 314079,
#     "total_api_duration_ms": 51403,
#     "total_lines_added": 11,
#     "total_lines_removed": 3
#   },
#   "context_window": {
#     "total_input_tokens": 2318,
#     "total_output_tokens": 2302,
#     "context_window_size": 200000,
#     "current_usage": {
#       "input_tokens": 10,
#       "output_tokens": 629,
#       "cache_creation_input_tokens": 2223,
#       "cache_read_input_tokens": 20184
#     }
#   },
#   "exceeds_200k_tokens": false
# }
