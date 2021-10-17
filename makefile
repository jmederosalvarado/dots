HOME := $(HOME)
BIN_HOME := $(HOME)/.local/bin
DATA_HOME := $(HOME)/.local/share
CONFIG_HOME := $(HOME)/.config

default:
	@echo "make [server | desktop]"

server: zsh nvim tools
desktop: i3 sway kitty
clean: sway_clean kitty_clean nvim_clean tools_clean

# Useful vars {{{

desktop_pkgs = pulseaudio.pkg pulseaudio-alsa.pkg \
							 pulseaudio-jack.pkg pulseaudio-bluetooth.pkg \
							 brightnessctl.pkg udisks2.pkg ntfs-3g.pkg \
							 mpd.pkg mpc.pkg mpv.pkg imv.pkg

xorg_pkgs = xorg-server.pkg

fonts_pkgs = ttc-iosevka.pkg ttf-fira-code.pkg ttf-nerd-fonts-symbols.pkg

# }}}

# Sway {{{

# Vars:
i3_pkgs = $(desktop_pkgs) $(xorg_pkgs)
i3_configs = $(CONFIG_HOME)/i3

# Rules:
i3: $(i3_configs) | $(i3_pkgs)

$(i3_configs): | $(CONFIG_HOME)
	ln -s $(PWD)/configs/xorg/$(notdir $@) $@

# Clean
i3_clean: | $(i3_pkgs:.pkg=.upkg)
	rm -f $(i3_configs)

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

$(sway_configs): | $(CONFIG_HOME)
	ln -s $(PWD)/configs/sway/$(notdir $@) $@

# Clean
sway_clean: | $(sway_pkgs:.pkg=.upkg)
	rm -f $(sway_configs)

# }}}

# Kitty {{{

kitty: $(CONFIG_HOME)/kitty | kitty.pkg

$(CONFIG_HOME)/kitty: | $(CONFIG_HOME)
	ln -s $(PWD)/configs/kitty $@

#Clean
kitty_clean: | kitty.upkg
	rm -f $(CONFIG_HOME)/kitty

# }}}

# ZSH {{{

zsh_pkgs = zsh.pkg
zsh_zplug = $(HOME)/.zplug
zsh_configs = $(HOME)/.zshrc $(HOME)/.zshenv $(HOME)/.zprofile

zsh: $(zsh_configs) $(zsh_zplug) starship | $(zsh_pkgs)

$(zsh_zplug): | git.pkg
	git clone https://github.com/zplug/zplug $@

$(zsh_configs):
	ln -s $(PWD)/configs/zsh/$(notdir $@) $@

starship: $(CONFIG_HOME)/starship.toml | starship.pkg

$(CONFIG_HOME)/starship.toml: | $(CONFIG_HOME)
	ln -s $(PWD)/configs/zsh/starship.toml $@

# Clean
zsh_clean: | $(zsh_pkgs:.pkg=.upkg)
	rm -rf $(zsh_zplug)
	rm -f $(zsh_configs) $(CONFIG_HOME)/starship.toml

# }}}

# Neovim {{{

# Vars:
nvim_configs = $(CONFIG_HOME)/nvim/init.lua $(CONFIG_HOME)/nvim/lua $(CONFIG_HOME)/nvim/after $(CONFIG_HOME)/nvim/config $(CONFIG_HOME)/nvim/coc-settings.json
nvim_packer = $(DATA_HOME)/nvim/site/pack/packer/start/packer.nvim
nvim_plug = $(DATA_HOME)/nvim/site/autoload/plug.vim
nvim_source = cache/nvim
nvim_build_deps = cmake.pkg unzip.pkg ninja.pkg tree-sitter.pkg curl.pkg
nvim_bin = /usr/local/bin/nvim

# Rules
nvim: $(nvim_bin) $(nvim_configs) $(nvim_packer) $(nvim_plug)

$(nvim_bin): $(nvim_source) | $(nvim_build_deps)
	$(MAKE) --directory $(nvim_source) CMAKE_BUILD_TYPE=Release
	sudo $(MAKE) --directory $(nvim_source) install

$(nvim_source): | git.pkg
	git clone https://github.com/neovim/neovim $@

$(CONFIG_HOME)/nvim:
	mkdir -p $@

$(nvim_configs): | $(CONFIG_HOME)/nvim
	ln -s $(PWD)/configs/nvim/$(notdir $@) $@

$(nvim_packer): | git.pkg
	git clone --depth 1 https://github.com/wbthomason/packer.nvim $@

$(nvim_plug): | curl.pkg
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Clean
nvim_clean: | $(nvim_build_deps:.pkg=.upkg)
	rm -rf $(nvim_packer)
	rm -f $(nvim_configs)
	# rm -rf $(nvim_source)
	# sudo rm -f $(nvim_bin)

# }}}

# Tools {{{

tools_pkgs = git.pkg github-cli.pkg gitlab-glab-bin.pkg \
						 docker.pkg docker-compose.pkg tmux.pkg ranger.pkg
tools_configs = $(CONFIG_HOME)/ranger

tools: $(tools_configs) | $(tools_pkgs)

$(tools_configs): | $(CONFIG_HOME)
	ln -s $(PWD)/configs/tools/$(notdir $@) $@

tools_clean: | $(tools_pkgs:.pkg=.upkg)
	rm -f $(tools_configs)

# }}}

# Scripts {{{

# TODO
scripts: $(BIN_HOME)
	ln -s $(PWD)/scripts/$(notdir $@) $@

scripts_clean:
	rm -f $(scripts)

# }}}

# Utils {{{

$(CONFIG_HOME) $(DATA_HOME) $(BIN_HOME):
	mkdir -p $@

%.pkg:
	paru -Qi $* &>/dev/null || paru -S --needed $*

%.upkg:
	# paru -Qi $* &>/dev/null && paru -R $*

# }}}
