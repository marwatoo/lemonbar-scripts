#!/bin/bash
. ~/.config/lemonbar/colors.sh

bat_path="/sys/class/power_supply/BAT0"

if [ ! -r "$bat_path/capacity" ]; then
    echo "%{U${alert}}%{+u}%{F${alert}}  ??%% %{F-}%{-u}%{U-}"
    exit
fi

cap=$(cat "$bat_path/capacity")
status=$(cat "$bat_path/status")

prefix=""
color="${alert}"
icon=""

if [ "$status" = "Charging" ]; then
    if [ "$cap" -eq 100 ]; then
        icon=""
        prefix="⚡️ "
        color="#00FF00"
    else
        icon=""
        color="#00FF00"
    fi
elif [ "$status" = "Discharging" ]; then
    icon=""
    color="#FF0000"
else
    if [ "$cap" -eq 100 ]; then
        icon=""
        prefix="⚡️ "
        color="#00FF00"
    fi
fi

echo "%{U${color}}%{+u}%{F${color}} ${prefix}${icon} ${cap}% %{F-}%{-u}%{U-}"
