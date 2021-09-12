require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	highlight = { enable = true },
	incremental_selection = { enable = true },
	indent = { enable = true, disable = { "python", "yaml" } },
	autopairs = { enable = true },
	autotag = { enable = true },
	matchup = { enable = true },

	playground = {
		enable = true,
		disable = {},
		updatetime = 25,
		persist_queries = false,
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
})

-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = vim.fn['nvim_treesitter#foldexpr']()
