#!/bin/sh

SWAY_SCRIPTS="$XDG_CONFIG_HOME/sway/scripts"

swayidle -w \
    timeout 300  "$SWAY_SCRIPTS/lock.sh --fade-in 0.5" \
    timeout 600  "swaymsg 'output * dpms off'" \
         resume  "swaymsg 'output * dpms on'" \
    before-sleep "$SWAY_SCRIPTS/lock.sh"
