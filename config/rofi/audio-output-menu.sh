#!/usr/bin/env bash

## Show available sinks
show_sinks() {
    # Get current default sink
    default_sink=$(pactl get-default-sink)
    
    pactl list sinks short | while read -r line; do
        sink_name=$(echo "$line" | awk '{print $2}')
        description=$(pactl list sinks | grep -A 20 "Name: $sink_name" | grep "Description:" | cut -d: -f2- | sed 's/^[[:space:]]*//')
        
        # Mark current default with indicator
        if [ "$sink_name" = "$default_sink" ]; then
            echo "󰄬 $description"
        else
            echo "  $description"
        fi
        
        # Store the mapping for later
        echo "$description|$sink_name" >> /tmp/rofi_sink_map
    done
}

# Clear previous mapping
rm -f /tmp/rofi_sink_map
touch /tmp/rofi_sink_map

# Show menu and get selection
selected=$(show_sinks | rofi -dmenu -p "Audio Output" -theme ~/.config/rofi/audiomenu.rasi)

if [ -n "$selected" ]; then
    # Remove indicator if present
    clean_selection=$(echo "$selected" | sed 's/^󰄬 //; s/^  //')
    
    # Find the sink name from our mapping
    sink_name=$(grep "$clean_selection" /tmp/rofi_sink_map | cut -d'|' -f2)
    
    if [ -n "$sink_name" ]; then
        pactl set-default-sink "$sink_name"
        # Move all current playing streams to new sink
        pactl list short sink-inputs | cut -f1 | while read -r stream; do
            pactl move-sink-input "$stream" "$sink_name"
        done
        notify-send "Audio Output" "Switched to: $clean_selection"
    fi
fi

# Cleanup
rm -f /tmp/rofi_sink_map
