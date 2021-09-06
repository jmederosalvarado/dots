if [ "$(tty)" = "/dev/tty1" ] && command -v sway &>/dev/null; then
  exec sway -d &>"$HOME/.local/share/sway.log" 
fi
