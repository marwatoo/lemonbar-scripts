#!/bin/bash

. ~/.config/lemonbar/colors.sh
. ~/.config/lemonbar/fonts.sh

padding=" "

while true; do
    left="%{l}${padding}$(~/.config/lemonbar/modules/workspaces.sh)${padding}"
    title="$(~/.config/lemonbar/modules/window.sh)"
    [ -n "$title" ] && center="%{c}${padding}%{F${window}}${title}%{F-}${padding}" || center="%{c}${padding}"
    right="%{r}${padding}$(~/.config/lemonbar/modules/wifi.sh) $(~/.config/lemonbar/modules/battery.sh) $(~/.config/lemonbar/modules/volume.sh) $(~/.config/lemonbar/modules/keyboard.sh) $(~/.config/lemonbar/modules/clock.sh)${padding}"

    echo "${left}${center}${right}"
    sleep 0.1
done | lemonbar -p -g 1911x28+3+5 -B "$bg" -F "$fg" -f "$font0" \
   | while read -r line; do
         eval "$line"
     done

