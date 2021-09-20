--[[
	TODO: check out this plugins
	- welle/targets.vim (and other text-object related)
	- iamcco/markdown-preview.nvim & npxbr/glow.nvim & plasticboy/vim-markdown
	- simrat39/symbols-outline.nvim
	- simrat39/rust-tools.nvim
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

	use({
		"neoclide/coc.nvim",
		branch = "release",
		config = use_config_viml("config/coc.vim"),
		disable = true,
	})

	use({
		"neovim/nvim-lspconfig",
		requires = {
			"kabouzeid/nvim-lspinstall",
			"folke/lua-dev.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jose-elias-alvarez/nvim-lsp-ts-utils",
			"folke/trouble.nvim",
			{
				"ms-jpq/coq_nvim",
				branch = "coq",
				requires = {
					"windwp/nvim-autopairs",
					"windwp/nvim-ts-autotag",
					{
						"ms-jpq/coq.artifacts",
						branch = "artifacts",
					},
				},
				config = use_config("config.coq"),
			},
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
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind-nvim",
			"windwp/nvim-autopairs",
			"windwp/nvim-ts-autotag",
		},
		config = use_config("config.cmp"),
		disable = true,
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

	use({ "tpope/vim-fugitive", requires = {
		"tpope/vim-rhubarb",
	} })
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
		"folke/tokyonight.nvim",
		requires = {
			"Luxed/ayu-vim",
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
				char = "┆", -- '|', '¦', '┆', '┊'
				filetype_exclude = { "packer", "help" },
				buftype_exclude = { "terminal" },
				-- bufname = { "terminal" },
				show_current_context = true,
				space_char_blankline = " ",
				use_treesitter = true,
				show_trailing_blankline_indent = false,
			})
		end,
		disable = false,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		config = use_setup("colorizer"),
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

	use("tpope/vim-commentary")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("tpope/vim-eunuch")
	use("tpope/vim-unimpaired")
	use("tpope/vim-abolish")
	use("tpope/vim-obsession")
	use("ggandor/lightspeed.nvim")
	use("andymass/vim-matchup")
	use("tjdevries/astronauta.nvim")
	use("tomlion/vim-solidity")
  use("wellle/targets.vim")

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
require("config.mappings")
