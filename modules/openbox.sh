#!/bin/bash

# Source color variables
. ~/.config/lemonbar/colors.sh

# Define 10 workspaces
ws_icons=("" "" "" "" "" "" "" "" "" "")
ws_num=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

# Get current and total desktops
current=$(wmctrl -d | awk '/\*/{print $1}')
total=$(wmctrl -d | wc -l)
if [ "$total" -lt 10 ]; then total=10; fi

# Get which workspaces have windows
windows=($(wmctrl -l | awk '{print $2}' | sort -n | uniq))

# Build output
out=""

for ((i=0; i<10; i++)); do
    ws_icon=${ws_icons[$i]}
    ws_label=${ws_num[$i]}
    click_start="%{A1:wmctrl -s $i:}"
    click_end="%{A}"

    # Detect if workspace has windows
    has_windows=false
    for w in "${windows[@]}"; do
        if [ "$w" -eq "$i" ]; then
            has_windows=true
            break
        fi
    done

    # Decide what to show:
    # - show icon if focused OR has windows
    # - show number if empty and not focused
    if [ "$i" -eq "$current" ] || [ "$has_windows" = true ]; then
        symbol="$ws_icon"
    else
        symbol="$ws_label"
    fi

    # Style output
    if [ "$i" -eq "$current" ]; then
        # Focused workspace
        out+="${click_start}%{U${primary}}%{+u}%{F${primary}} ${symbol} %{F-}%{-u}%{U-}${click_end} "
    elif [ "$has_windows" = true ]; then
        # Has windows but not focused
        out+="${click_start}%{U${secondary}}%{+u} ${symbol} %{-u}%{U-}${click_end} "
    else
        # Empty and unfocused
        out+="${click_start}%{F${foreground}} ${symbol} %{F-}${click_end} "
    fi
done

# Output for lemonbar
echo " $out"

