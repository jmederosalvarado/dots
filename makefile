HOME := $(HOME)
BIN_HOME := $(HOME)/.local/bin
DATA_HOME := $(HOME)/.local/share
CONFIG_HOME := $(HOME)/.config

all: sway zsh nvim tools
clean: sway_clean zsh_clean nvim_clean tools_clean

# Useful vars {{{

desktop_pkgs = pulseaudio.pkg pulseaudio-alsa.pkg \
							 pulseaudio-jack.pkg pulseaudio-bluetooth.pkg \
							 brightnessctl.pkg udisks2.pkg ntfs-3g.pkg \
							 mpd.pkg mpc.pkg mpv.pkg imv.pkg

fonts_pkgs = ttc-iosevka.pkg ttf-fira-code.pkg ttf-nerd-fonts-symbols.pkg

# }}}

# Sway {{{

# Vars:
sway_pkgs = sway.pkg swayidle.pkg swaylock-effects.pkg \
						sway-launcher-desktop.pkg mako.pkg waybar.pkg \
						grim.pkg grimshot.pkg slurp.pkg wl-clipboard.pkg \
						$(desktop_pkgs)
sway_configs = $(CONFIG_HOME)/sway $(CONFIG_HOME)/mako \
							 $(CONFIG_HOME)/waybar $(CONFIG_HOME)/swaylock

# Rules:
sway: $(sway_configs) | $(sway_pkgs)

$(sway_configs):
	mkdir -p $(dir $@)
	ln -s $(PWD)/configs/sway/$(notdir $@) $@

# Clean
sway_clean: | $(sway_pkgs:.pkg=.upkg)
	rm -f $(sway_configs)

# }}}

# ZSH {{{

zsh_pkgs = zsh.pkg
zsh_zplug = $(HOME)/.zplug
zsh_configs = $(HOME)/.zshrc $(HOME)/.zshenv $(HOME)/.zprofile

zsh: $(zsh_configs) $(CONFIG_HOME)/starship.toml | $(zsh_pkgs)

$(zsh_zplug): | git.pkg
	git clone https://github.com/zplug/zplug $@

$(zsh_configs):
	mkdir -p $(dir $@)
	ln -s $(PWD)/configs/zsh/$(notdir $@) $@

$(CONFIG_HOME)/starship.toml:
	mkdir -p $(dir $@)
	ln -s $(PWD)/configs/zsh/starship.toml $@

# Clean
zsh_clean: | $(zsh_pkgs:.pkg=.upkg)
	rm -rf $(zsh_zplug)
	rm -f $(zsh_configs) $(CONFIG_HOME)/starship.toml

# }}}

# Neovim {{{

# Vars:
nvim_configs = $(CONFIG_HOME)/nvim/init.lua $(CONFIG_HOME)/nvim/lua
nvim_packer = $(DATA_HOME)/nvim/site/pack/packer/start/packer.nvim
nvim_source = cache/nvim
nvim_build_deps = base-devel.pkg cmake.pkg unzip.pkg ninja.pkg tree-sitter.pkg curl.pkg
nvim_bin = /usr/local/bin/nvim

# Rules
nvim: $(nvim_bin) $(nvim_configs)

$(nvim_bin): $(nvim_source) | $(nvim_build_deps)
	$(MAKE) --directory $(nvim_source) CMAKE_BUILD_TYPE=Release
	sudo $(MAKE) --directory $(nvim_source) install

$(nvim_source): | git.pkg
	git clone --depth 1 https://github.com/neovim/neovim $@

$(nvim_configs):
	mkdir -p $(CONFIG_HOME)/nvim
	ln -s $(PWD)/configs/nvim/$(notdir $@) $@

$(nvim_packer): | git.pkg
	git clone --depth 1 https://github.com/wbthomason/packer.nvim $@

# Clean
nvim_clean: | $(nvim_build_deps:.pkg=.upkg)
	rm -rf $(nvim_source) $(nvim_packer)
	rm -f $(nvim_configs)
	sudo rm -f $(nvim_bin)

# }}}

# Tools {{{

tools_pkgs = git.pkg github-cli.pkg gitlab-glab-bin.pkg \
						 docker.pkg docker-compose.pkg tmux.pkg ranger.pkg

tools: | $(tools_pkgs)

tools_clean: | $(tools_pkgs:.pkg=.upkg)

# }}}

# Scripts {{{

# TODO
scripts:
	mkdir -p $(dir $@)
	ln -s $(PWD)/scripts/$(notdir $@) $@

scripts_clean:
	rm -f $(scripts)

# }}}

# Utils {{{

%.pkg:
	paru -Qi $* &>/dev/null || paru -S --needed $*

%.upkg:
	paru -Qi $* &>/dev/null && paru -R $*

# }}}
