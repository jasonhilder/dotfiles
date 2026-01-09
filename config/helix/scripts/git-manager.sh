#!/usr/bin/env bash
# 
lazygit
if [[ $? -eq 0 ]]; then
	tmux last-window
	tmux send-keys Escape
	tmux send-keys ":$1"
	tmux send-keys Enter
else
	tmux kill-window -t gx
fi
