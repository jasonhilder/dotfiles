#!/bin/bash

# Check if a scratchpad-notepad window already exists in i3's tree
EXISTS=$(i3-msg -t get_tree | jq '.. | select(.window_properties?.instance? == "scratchpad-notepad") | .id' | head -n1)

if [ -z "$EXISTS" ]; then
    # Doesn't exist yet — create it
    kitty --class scratchpad-notepad -e vim /home/jason/.scratchpad &
    exit 0
fi

# Check if it's currently visible (floating node not in scratchpad)
VISIBLE=$(i3-msg -t get_tree | jq '.. | select(.window_properties?.instance? == "scratchpad-notepad" and .focused == true)' | head -n1)

if [ -n "$VISIBLE" ]; then
    # It's visible (focused or on workspace) — hide it
    i3-msg '[instance="scratchpad-notepad"] move scratchpad' >/dev/null
else
    # It's hidden — show it
    i3-msg '[instance="scratchpad-notepad"] scratchpad show' >/dev/null
fi
