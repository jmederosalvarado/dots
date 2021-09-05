vim.g.nvim_tree_width = 50;
vim.g.nvim_tree_follow = 1;
vim.g.nvim_tree_disable_netrw = 0;
vim.g.nvim_tree_hijack_netrw = 0;
vim.g.nvim_tree_lsp_diagnostics = 1;
vim.g.nvim_tree_quit_on_open = 1;
-- vim.g.nvim_tree_auto_open = 1;
vim.g.nvim_tree_auto_close = 1;

vim.cmd 'nnoremap <C-n> :NvimTreeToggle<CR>'
-- vim.cmd 'nnoremap - :NvimTreeFindFile<CR>'

vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 0,
}

vim.g.nvim_tree_icons = {
  default= '';
  symlink= '';
  git= {
    unstaged = "!",
    staged = "+",
    unmerged = "",
    renamed = "»",
    untracked = "?",
    deleted = "✗",
    ignored = "◌"
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
  }
}
