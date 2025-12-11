#!/bin/bash

# Source color variables
. ~/.config/lemonbar/colors.sh

# Read desktop names into an array
mapfile -t desktops < <(bspc query -D --names 2>/dev/null)

# Define workspace icons
ws_icons=("" "" "" "" "" "" "" "" "" "")
ws_num=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

# Get the name of the focused desktop
focused=$(bspc query -D -d focused --names 2>/dev/null)

# Initialize the output string
out=""

# Loop through each desktop
for idx in "${!desktops[@]}"; do
    d=${desktops[$idx]}
    count=$(bspc query -N -d "$d" 2>/dev/null | wc -l)

    # Decide symbol
    if [ "$d" = "$focused" ]; then
        ws_symbol=${ws_icons[$idx]:-${ws_num[$idx]}}
    elif [ "$count" -eq 0 ]; then
        ws_symbol=${ws_num[$idx]}
    else
        ws_symbol=${ws_icons[$idx]:-${ws_num[$idx]}}
    fi

    # Clickable wrapper: left-click → focus desktop
    click_start="%{A1:bspc desktop -f $d:}"
    click_end="%{A}"

    if [ "$d" = "$focused" ]; then
        # Focused desktop → underline + primary color
        out+="${click_start}%{U${primary}}%{+u}%{F${primary}} ${ws_symbol} %{F-}%{-u}%{U-}${click_end} "
    elif [ "$count" -gt 0 ]; then
        # Not focused but not empty → underline only
        out+="${click_start}%{+u} ${ws_symbol} %{-u}${click_end} "
    else
        # Empty & unfocused → plain
        out+="${click_start} ${ws_symbol} ${click_end} "
    fi
done

# Print the final formatted string for the bar
echo " $out"

