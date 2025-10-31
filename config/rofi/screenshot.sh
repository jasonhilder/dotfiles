#!/usr/bin/env bash

## Options
fullscreen="󰹑 Fullscreen"
area="󰩭 Select Area"
window="󰖲 Current Window"
delay5="󱎫 Fullscreen (5s delay)"

## Screenshots directory
screenshot_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshot_dir"

## Rofi command
rofi_cmd() {
    rofi -dmenu \
        -i \
        -p "Screenshot" \
        -theme ~/.config/rofi/screenshot.rasi
}

## Main menu
run_rofi() {
    echo -e "$fullscreen\n$area\n$window\n$delay5" | rofi_cmd
}

## Take screenshot
take_screenshot() {
    local filename="$screenshot_dir/screenshot_$(date +%Y%m%d_%H%M%S).png"
    
    case "$1" in
        fullscreen)
            maim "$filename"
            ;;
        area)
            maim -s "$filename"
            ;;
        window)
            maim -i $(xdotool getactivewindow) "$filename"
            ;;
        delay)
            sleep 5
            maim "$filename"
            ;;
    esac
    
    if [ -f "$filename" ]; then
        notify-send "Screenshot" "Saved to $(basename $filename)"
        xclip -selection clipboard -t image/png -i "$filename"
    else
        notify-send "Screenshot" "Failed to capture screenshot"
    fi
}

## Execute Command
case "$(run_rofi)" in
    "$fullscreen")
        take_screenshot fullscreen
        ;;
    "$area")
        take_screenshot area
        ;;
    "$window")
        take_screenshot window
        ;;
    "$delay5")
        take_screenshot delay
        ;;
esac
