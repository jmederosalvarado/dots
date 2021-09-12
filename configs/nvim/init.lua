--[[
	TODO: check out this plugins
	- akinsho/nvim-bufferline.lua
	- welle/targets.vim (and other text-object related)
	- iamcco/markdown-preview.nvim & npxbr/glow.nvim & plasticboy/vim-markdown
	- simrat39/symbols-outline.nvim
	- simrat39/rust-tools.nvim
	- norcalli/nvim-terminal.lua
--]]

local use_config = function(config)
	return string.format([[require '%s']], config)
end

local use_setup = function(name)
	return string.format([[require'%s'.setup {}]], name)
end

local use_config_viml = function(config)
	return string.format([[vim.cmd 'runtime %s']], config)
end

local plugins = function(use)
	use("wbthomason/packer.nvim")

	-- TODO: Stop using coc
	use({
		"neoclide/coc.nvim",
		branch = "release",
		config = use_config_viml("config/coc.vim"),
		disable = true,
	})

	use({
		"neovim/nvim-lspconfig",
		requires = {
			"folke/lua-dev.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jose-elias-alvarez/nvim-lsp-ts-utils",
			"folke/trouble.nvim",
			"kabouzeid/nvim-lspinstall",
			-- "glepnir/lspsaga.nvim",
		},
		config = use_config("config.lsp"),
		disable = false,
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			-- "hrsh7th/cmp-vsnip",
			-- "hrsh7th/vim-vsnip",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind-nvim",
			"windwp/nvim-autopairs",
			"windwp/nvim-ts-autotag",
		},
		config = use_config("config.cmp"),
		disable = false,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = use_config("config.treesitter"),
	})

	use({
		"nvim-telescope/telescope.nvim",
		config = use_config("config.telescope"),
		requires = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
	})

	-- git {{{

	use("tpope/vim-fugitive")
	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
	})
	use("sindrets/diffview.nvim")
	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = use_setup("gitsigns"),
	})

	-- }}}

	-- appearance {{{

	use({
		-- 'Luxed/ayu-vim',
		"folke/tokyonight.nvim",
		requires = {
			"kyazdani42/nvim-tree.lua",
			"hoob3rt/lualine.nvim",
		},
		config = use_config("config.appearance"),
	})
	use({
		"karb94/neoscroll.nvim",
		config = use_setup("neoscroll"),
	})
	use({
		"edluffy/specs.nvim",
		-- after = "neoscroll.nvim",
		config = use_setup("specs"),
	})
	use({
		"folke/zen-mode.nvim",
		config = use_setup("zen-mode"),
		requires = {
			"folke/twilight.nvim",
		},
	})
	use({
		"folke/todo-comments.nvim",
		config = use_setup("todo-comments"),
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				show_current_context = true,
				-- space_char_blankline = " ",
			})
		end,
		disable = true,
	})
	use("kyazdani42/nvim-web-devicons")

	-- }}}

	-- misc {{{

	use({
		"folke/persistence.nvim",
		config = function()
			require("persistence").setup()
			vim.cmd('command! SessionLoad  lua require("persistence").load()')
			vim.cmd('command! SessionLast  lua require("persistence").load({ last = true })')
			vim.cmd('command! SessionStop  lua require("persistence").stop()')
			vim.cmd('command! SessionStart lua require("persistence").start()')
		end,
	})

	use("tpope/vim-vinegar")
	use("tpope/vim-commentary")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("tpope/vim-eunuch")
	use("tpope/vim-unimpaired")
	use("tpope/vim-abolish")
	use("tpope/vim-obsession")
	use("ggandor/lightspeed.nvim")
	use("andymass/vim-matchup")
	-- use 'romgrk/barbar.nvim'

	-- }}}
end

require("packer").startup({
	plugins,
	config = {
		display = {
			profile = true,
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})

require("config.options")
