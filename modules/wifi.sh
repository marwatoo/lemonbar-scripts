#!/bin/bash
. ~/.config/lemonbar/colors.sh

ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')
[ -z "$ssid" ] && ssid="??"

echo "%{U${pink}}%{+u}%{F${pink}}  ${ssid} %{F-}%{-u}%{U-}"
