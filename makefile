BIN_HOME = $(HOME)/.local/bin
DATA_HOME = $(HOME)/.local/share
CONFIG_HOME = $(HOME)/.config

# Sway {{{

# Vars:
sway_pkgs = sway.pkg mako.pkg waybar.pkg swaylock-effects.pkg
sway_configs = $(CONFIG_HOME)/sway $(CONFIG_HOME)/mako \
							 $(CONFIG_HOME)/waybar $(CONFIG_HOME)/swaylock

# Rules:
sway: $(sway_pkgs) $(sway_configs)

$(sway_configs):
	ln -s $(PWD)/configs/sway/$(notdir $@) $@

# }}}

# ZSH {{{

zsh_pkgs = $(HOME)/.zplug zsh.pkg
zsh_configs = $(HOME)/.zshrc $(HOME)/.zshenv $(HOME)/.zprofile

zsh: $(zsh_pkgs) $(zsh_configs) $(CONFIG_HOME)/starship.toml

$(zsh_configs):
	ln -s $(PWD)/configs/zsh/$(notdir $@) $@

$(CONFIG_HOME)/starship.toml:
	ln -s $(PWD)/configs/zsh/starship.toml $@

$(HOME)/.zplug: | git.pkg
	git clone https://github.com/zplug/zplug $@

# }}}

# Neovim {{{

nvim_configs = $(CONFIG_HOME)/nvim/lua $(CONFIG_HOME)/nvim/init.lua

# }}}

tools: nvim tmux docker git dev

%.pkg:
	paru -Qi $* || paru -S --needed $*
