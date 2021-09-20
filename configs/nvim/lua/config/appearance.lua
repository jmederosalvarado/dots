-- COLORSCHEME {{{

vim.o.background = "dark"

-- vim.g.tokyonight_style = "night" -- storm is the default
-- vim.g.tokyonight_colors = { bg_dark = "#16161e" }
-- vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_lualine_bold = true

vim.cmd("colorscheme tokyonight")

-- }}}

-- LUALINE {{{

require("lualine").setup({
	options = {
		icons_enabled = true,
		-- theme = 'ayu_mirage',
		theme = "tokyonight",
		component_separators = { "│", "│" },
		section_separators = { "", "" },
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "nvim-tree", "fugitive" },
})

-- }}}

-- NVIM-TREE {{{

-- vim.g.nvim_tree_width = 50;
-- vim.g.nvim_tree_follow = 1
-- vim.g.nvim_tree_lsp_diagnostics = 1
-- vim.g.nvim_tree_quit_on_open = 1;
-- vim.g.nvim_tree_auto_open = 1;
-- vim.g.nvim_tree_auto_close = 1;
vim.g.nvim_tree_ignore = { '.git', 'node_modules' }

vim.cmd("nnoremap <C-n> :NvimTreeToggle<CR>")
vim.cmd("nnoremap - :NvimTreeFindFile<CR>")

vim.g.nvim_tree_show_icons = {
	git = 1,
	folders = 1,
	files = 1,
	folder_arrows = 0,
}

vim.g.nvim_tree_icons = {
	default = "",
	symlink = "",
	git = {
		unstaged = "!",
		staged = "+",
		unmerged = "",
		renamed = "»",
		untracked = "?",
		deleted = "✗",
		ignored = "◌",
	},
	folder = {
		arrow_open = "",
		arrow_closed = "",
		default = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
		symlink_open = "",
	},

	lsp = {
		hint = "",
		info = "",
		warning = "",
		error = "",
	},
}

-- }}}
