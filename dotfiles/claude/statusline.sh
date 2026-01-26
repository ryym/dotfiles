#!/bin/bash

# A script to build a simple Claude Code statusline like below.
# [Sonnet 4.5] $0.09 | 24495.0s | 1731 tokens

# Read JSON input from stdin.
context=$(cat)

# Extract values from JSON.
     model=$(echo "$context" | jq -r '.model.display_name')
      cost=$(echo "$context" | jq -r '.cost.total_cost_usd')
    tokens=$(echo "$context" | jq -r '.context_window.total_input_tokens')
  duration=$(echo "$context" | jq -r '.cost.total_duration_ms')
ctx_amount=$(echo "$context" | jq '.context_window.remaining_percentage')

# Format values.
cost_formatted=$(awk "BEGIN {printf \"%.2f\", int($cost * 100 + 1) / 100}")
duration_sec=$(awk "BEGIN {printf \"%.1f\", $duration / 1000}")
if [ "$ctx_amount" = "null" ]; then
  ctx_amount="  "
fi

# Format output.
echo "[$model] ctx:${ctx_amount}% | \$${cost_formatted} | ${tokens} tokens | ${duration_sec}s"

# As a reference, context information Claude Code provides looks like below (as of 2026-01):
# {
#   "session_id": "<session-id>",
#   "transcript_path": "/home/ryu/.claude/projects/-home-ryu--dotfiles/<session-id>.jsonl",
#   "cwd": "/home/ryu/.dotfiles",
#   "model": {
#     "id": "claude-opus-4-5-20251101",
#     "display_name": "Opus 4.5"
#   },
#   "workspace": {
#     "current_dir": "/home/ryu/.dotfiles",
#     "project_dir": "/home/ryu/.dotfiles"
#   },
#   "version": "2.1.12",
#   "output_style": {
#     "name": "default"
#   },
#   "cost": {
#     "total_cost_usd": 0.05428175,
#     "total_duration_ms": 45959,
#     "total_api_duration_ms": 9062,
#     "total_lines_added": 0,
#     "total_lines_removed": 0
#   },
#   "context_window": {
#     "total_input_tokens": 532,
#     "total_output_tokens": 329,
#     "context_window_size": 200000,
#     "current_usage": {
#       "input_tokens": 10,
#       "output_tokens": 6,
#       "cache_creation_input_tokens": 6325,
#       "cache_read_input_tokens": 13987
#     },
#     "used_percentage": 10,
#     "remaining_percentage": 90
#   },
#   "exceeds_200k_tokens": false
# }
