#!/bin/bash
. ~/.config/lemonbar/colors.sh

icon=""

# Run KDE Connect once
data=$(kdeconnect-cli -a 2>/dev/null)

# Extract first reachable + paired device
device_line=$(echo "$data" | grep "(paired and reachable)" | head -n 1)

# If no device found
if [ -z "$device_line" ]; then
    echo ""
    exit 0
fi

# Extract device name before the colon
device_name=$(echo "$device_line" | sed 's/^- \(.*\):.*/\1/')

# Output in lemonbar style
echo "%{U${cpu_col}}%{+u}%{F${cpu_col}} ${icon} ${device_name} %{F-}%{-u}%{U-}"

