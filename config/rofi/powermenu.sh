#!/usr/bin/env bash

## Options
shutdown="󰐥 Shutdown"
reboot="󰜉 Restart"
logout="󰍃 Logout"
lock="󰌾 Lock"
suspend="󰤄 Suspend"

## Rofi command
rofi_cmd() {
    rofi -dmenu \
		-i \
        -p "" \
        -theme ~/.config/rofi/powermenu.rasi
}

## Pass variables to rofi dmenu
run_rofi() {
    echo -e "$shutdown\n$reboot\n$logout\n$lock" | rofi_cmd
}

## Execute Command
case "$(run_rofi)" in
    "$logout")
        i3-msg exit
        ;;
    "$lock")
        loginctl lock-session
        ;;
    "$reboot")
        loginctl reboot
        ;;
    "$shutdown")
        loginctl poweroff
        ;;
esac
