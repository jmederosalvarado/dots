require("astronauta.keymap")
local nnoremap = vim.keymap.nnoremap

require("telescope").setup({
	defaults = {
		prompt_prefix = "# ",
		selection_caret = "❯ ",
	},
})

nnoremap({ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>" })
nnoremap({ "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>" })
nnoremap({ "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>" })
nnoremap({ "<leader>fb", "<cmd>lua require('telescope.builtin').help_tags()<cr>" })
