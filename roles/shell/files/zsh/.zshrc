# TABLE OF CONTENTS {{{

# OPTIONS
# COMPLETIONS
# KEYBINDINGS
# HISTORY
# PLUGINS
# ALIASES
# PATH

# }}}

# OPTIONS {{{

# Changing/making/removing directory
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

setopt interactivecomments  # Recognize comments
setopt multios              # Allow multiple redirection streams

# }}}

# COMPLETIONS {{{

# Load all stock functions (from $fpath files) called below.
autoload -U compinit && compinit -d "$HOME/.zcompdump"

# This settings are a simplification of settings at
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/completion.zsh

# fixme - the load process here seems a bit bizarre
zmodload -i zsh/complist

unsetopt menu_complete   # do not autoselect the first completion entry
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# zstyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# define completers
zstyle ":completion:*" completer _complete _match _approximate

zstyle ':completion:*:*:*:*:*' menu select

# case insensitive (all), partial-word and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*' # hyphen insensitive
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # hyphen sensitive

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# automatically expand ... to ../..
# taken from zsh-lovers
function rationalise_dot {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise_dot
bindkey . rationalise_dot

# use caching so that commands like apt and dpkg complete are usable
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zshcompdump"

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

# }}}

# KEYBINDINGS {{{

# Start typing + [key] - fuzzy find history backward {{{

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

bindkey -M viins "^[[A" up-line-or-beginning-search
bindkey -M vicmd "^[[A" up-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search

# }}}

# Start typing + [key] - fuzzy find history forward {{{

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M viins "^[[B" down-line-or-beginning-search
bindkey -M vicmd "^[[B" down-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# }}}

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M viins '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M viins "${terminfo[kdch1]}" delete-char
else
  bindkey -M viins "^[[3~" delete-char
  bindkey -M viins "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M viins '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

# [Space] - don't do history expansion
bindkey ' ' magic-space

# Setup vi-mode

# Variable to track keymap mode
typeset -g VI_KEYMAP=main

# Control cursor style on mode change.
function _vi-mode-set-cursor-shape-for-keymap() {
  # return # uncomment to not change cursor style

  # https://vt100.net/docs/vt510-rm/DECSCUSR
  local _shape=0
  case "${1:-${VI_KEYMAP:-main}}" in
    main)    _shape=6 ;; # vi insert: line
    viins)   _shape=6 ;; # vi insert: line
    isearch) _shape=6 ;; # inc search: line
    command) _shape=6 ;; # read a command name
    vicmd)   _shape=2 ;; # vi cmd: block
    visual)  _shape=2 ;; # vi visual mode: block
    viopp)   _shape=0 ;; # vi operation pending: blinking block
    *)       _shape=0 ;;
  esac
  printf $'\e[%d q' "${_shape}"
}

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  typeset -g VI_KEYMAP=$KEYMAP
  _vi-mode-set-cursor-shape-for-keymap "${VI_KEYMAP}"
}
zle -N zle-keymap-select

function zle-line-init() {
  typeset -g VI_KEYMAP=main
  (( ! ${+terminfo[smkx]} )) || echoti smkx
  _vi-mode-set-cursor-shape-for-keymap "${VI_KEYMAP}"
}
zle -N zle-line-init

function zle-line-finish() {
  typeset -g VI_KEYMAP=main
  (( ! ${+terminfo[rmkx]} )) || echoti rmkx
  _vi-mode-set-cursor-shape-for-keymap default
}
zle -N zle-line-finish

bindkey -v

# allow vv to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# allow ctrl-p, ctrl-n for fuzzy seach
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# }}}

# HISTORY {{{

HISTFILE="$HOME/.zhistory" 
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Show history timestamps
alias history='history -f' # timestamps follow mm/dd/yyyy
# alias history='history -E' # timestamps follow dd.mm.yyyy
# alias history='history -i' # timestamps follow yyyy-mm-dd

# }}}

# PLUGINS {{{

# Configure syntax-highlighting and autosuggestions
#source_opt "$XDG_DATA_HOME/zsh/site/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
#source_opt "$XDG_DATA_HOME/zsh/site/zsh-autosuggestions/zsh-autosuggestions.zsh"

# }}}

# ALIASES {{{

alias l='ls -lah'
alias ll='ls -lh'

# }}}

# PATH {{{

# Add path to user local tools
export PATH="$HOME/.local/bin:$PATH"

# }}}

eval "$(starship init zsh)"
