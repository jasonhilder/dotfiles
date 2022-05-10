#!/bin/bash
echo "Name New Session: "
read _name

tmux new -d -s $_name && tmux switch-client -t $_name
