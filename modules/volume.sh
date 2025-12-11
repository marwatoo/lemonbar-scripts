#!/bin/bash
. ~/.config/lemonbar/colors.sh

# Cache file for earbuds info
earbuds_cache="$HOME/.config/lemonbar/cache/earbuds.txt"
earbuds_cache_ttl=30  # seconds

get_mic_status() {
  default_source=$(pactl info | grep "Default Source" | sed 's/^[^:]*: *//')
  if [ -z "$default_source" ]; then
    echo "󰍬"
    return
  fi

  if pactl get-source-mute "$default_source" | grep -q "yes"; then
    # Muted
    echo ""
  else
    # Active
    echo ""
  fi
}

get_earbuds_info() {
    # If cache exists and is fresh, return it
    if [ -f "$earbuds_cache" ]; then
        last_update=$(stat -c %Y "$earbuds_cache")
        now=$(date +%s)
        if (( now - last_update < earbuds_cache_ttl )); then
            cat "$earbuds_cache"
            return
        fi
    fi

    # Scan connected Bluetooth devices
    connected_devices=$(bluetoothctl devices Connected | awk '{print $2}')
    result=""

    for dev_mac in $connected_devices; do
        dev_name=$(bluetoothctl info "$dev_mac" | awk -F ': ' '/Name/ {print $2}')
        if echo "$dev_name" | grep -qiE "earbud|headset|airpods|buds|sony|bose|jabra"; then
            # Try UPower first
            upower_path=$(upower -e | grep -i "$dev_mac")
            battery=""
            if [ -n "$upower_path" ]; then
                battery=$(upower -i "$upower_path" | awk '/percentage/ {print $2}' | tr -d '%')
            fi
            # Fallback to bluetoothctl battery
            if [ -z "$battery" ]; then
                battery=$(bluetoothctl info "$dev_mac" | grep -i "Battery Percentage" | sed -n 's/.*(\([0-9]\+\)).*/\1/p')
            fi
            if [ -n "$battery" ]; then
                result="$dev_name|$battery"
                echo "$result" > "$earbuds_cache"
                echo "$result"
                return
            fi
        fi
    done

    # If no earbuds found, clear cache
    echo "" > "$earbuds_cache"
    echo ""
}

default_sink=$(pactl info | awk -F': ' '/Default Sink/ {print $2}' | xargs)

    if [ -z "$default_sink_cache" ]; then
        default_sink_cache=$(pactl info | awk -F': ' '/Default Sink/ {print $2}' | xargs)
    fi

    # Check mute status
    if pactl get-sink-mute "$default_sink_cache" | grep -q "yes"; then
        echo "%{U${disabled}}%{+u}%{F${disabled}}  mute %{F-}%{-u}%{U-}"
    else
        # Get current volume (first channel)
        vol=$(pactl get-sink-volume "$default_sink_cache" | grep -oP '\d+?(?=%)' | head -n 1)
        [ "$vol" -gt 100 ] && vol=100

        # Get earbuds info from cache
        earbuds_info=$(get_earbuds_info)
        if [ -n "$earbuds_info" ]; then
            earbuds_battery=${earbuds_info##*|}
            echo "%{U${orange}}%{+u}%{F${orange}}  ${vol}%   ${earbuds_battery}% $(get_mic_status)%{F-}%{-u}%{U-}"
        else
            echo "%{U${orange}}%{+u}%{F${orange}}  ${vol}% $(get_mic_status)%{F-}%{-u}%{U-}"
        fi
    fi
