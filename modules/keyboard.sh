#!/bin/bash
. ~/.config/lemonbar/colors.sh

layout=$(xkb-switch 2>/dev/null)
[ -z "$layout" ] && layout="??"

echo "%{U${window}}%{+u}%{F${window}}  ${layout} %{F-}%{-u}%{U-}"
