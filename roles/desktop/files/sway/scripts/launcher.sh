#!/bin/sh

alacritty \
    --class 'alacritty-launcher' \
    --command bash -c 'compgen -c | sort -u | fzf --reverse | xargs -r swaymsg -t command exec'
