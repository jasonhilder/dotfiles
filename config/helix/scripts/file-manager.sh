#!/usr/bin/env bash
# 
temp_file=$(mktemp)
lf -selection-path="$temp_file"
paths=$(cat "$temp_file")
rm "$temp_file"

if [[ -n "$paths" ]]; then
	tmux last-window
	tmux send-keys Escape
	tmux send-keys ":$1 $paths"
	tmux send-keys Enter
else
	tmux kill-window -t fx
fi
