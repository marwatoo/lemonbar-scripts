#!/bin/bash
. ~/.config/lemonbar/colors.sh

pt=$(pidof trayer)
# If trayer is running → output empty string
if [ -n "$pt" ]; then
    echo ""
    exit 0
fi

wid=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $5}')
[ -z "$wid" ] || [ "$wid" = "0x0" ] && exit

title=$(xprop -id "$wid" WM_NAME 2>/dev/null | cut -d '"' -f2)

# UTF-8 safe: count characters using wc -m
len=$(printf "%s" "$title" | wc -m)

if [ "$len" -gt 15 ]; then
    short_title="$(printf "%s" "$title" | cut -c1-20)…"
else
    short_title="$title"
fi

echo "$short_title"

