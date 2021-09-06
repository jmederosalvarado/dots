--[[
	TODO: check out this plugins
	- akinsho/nvim-bufferline.lua
	- welle/targets.vim (and other text-object related)
	- andymass/vim-matchup
	- iamcco/markdown-preview.nvim & npxbr/glow.nvim & plasticboy/vim-markdown
	- simrat39/symbols-outline.nvim
	- simrat39/rust-tools.nvim
	- glepnir/dashboard-nvim
	- norcalli/nvim-terminal.lua
	- windwp/nvim-spectre
	- folke/persistence.nvim
--]]

local use_config = function (config)
	return string.format([[require '%s']], config)
end

local use_setup = function (name)
	return string.format([[require'%s'.setup {}]], name)
end

local use_config_viml = function (config)
	return string.format([[vim.cmd 'runtime %s']], config)
end

local plugins = function(use)
	use 'wbthomason/packer.nvim'

	-- TODO: Stop using coc
	use {
		'neoclide/coc.nvim',
                branch = 'release',
		config = use_config_viml 'config/coc.nvim'
	}

	use {
		'neovim/nvim-lspconfig',
		requires = {
			'folke/lua-dev.nvim',
			'null-ls.nvim',
			'nvim-lsp-ts-utils',
			'folke/trouble.nvim',
		},
		config = use_config 'config.lsp',
		disable = true,
	}

	use {
		'hrsh7th/nvim-compe',
		requires = {
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets',
			'nvim-autopairs',
		},
		config = use_config 'config.completion',
		disable = true,
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		requires = {
			'nvim-treesitter/playground',
			'nvim-treesitter/nvim-treesitter-textobjects'
		},
		config = use_config 'config.treesitter'
	}

	use {
		'nvim-telescope/telescope.nvim',
		config = use_config 'config.telescope',
		requires = {
			'nvim-lua/popup.nvim',
			'nvim-lua/plenary.nvim',
		}
	}

	-- git {{{


	use 'tpope/vim-fugitive'
	use {
		'TimUntersberger/neogit',
		requires = 'nvim-lua/plenary.nvim'
	}
	use 'sindrets/diffview.nvim'
	use {
	  'lewis6991/gitsigns.nvim',
	  requires = 'nvim-lua/plenary.nvim',
	  config = use_setup 'gitsigns'
	}
	
	-- }}}

	-- appearance {{{

	use {
		'Luxed/ayu-vim',
		config = use_config 'config.colorscheme'
	}
	use {
		'hoob3rt/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons' },
		config = use_config 'config.lualine'
	}
	use {
		'kyazdani42/nvim-tree.lua',
		config = use_config 'config.tree'
	}
	use {
		'karb94/neoscroll.nvim',
		config = use_setup 'neoscroll'
	}
	use {
		'edluffy/specs.nvim',
		-- after = "neoscroll.nvim",
		config = use_setup 'specs'
	}
	use {
		'folke/zen-mode.nvim',
		config = use_setup 'zen-mode',
		requires = {
			'folke/twilight.nvim'
		}
	}
	use {
		'folke/todo-comments.nvim',
		config = use_setup 'todo-comments'
	}

	-- }}}

	-- misc {{{

	use 'tpope/vim-vinegar'
	use 'tpope/vim-commentary'
	use 'tpope/vim-surround'
	use 'tpope/vim-repeat'
	use 'tpope/vim-eunuch'
	use 'tpope/vim-unimpaired'
	use 'tpope/vim-abolish'
	use 'tpope/vim-obsession'
	use 'ggandor/lightspeed.nvim'

	-- }}}
end

require'packer'.startup({ plugins, config = {
	display = {
		profile = true,
		open_fn = function ()
			return require'packer.util'.float({ border = 'single' })
		end
	}
}})

require 'config.options'
