-- TODO: check out this plugins
--
-- - akinsho/nvim-bufferline.lua
-- - welle/targets.vim (and other text-object related)
-- - andymass/vim-matchup
-- - iamcco/markdown-preview.nvim & npxbr/glow.nvim & plasticboy/vim-markdown
--   --------------------------
-- - simrat39/symbols-outline.nvim
-- - simrat39/rust-tools.nvim
-- - glepnir/dashboard-nvim
-- - norcalli/nvim-terminal.lua
-- - windwp/nvim-spectre
-- - folke/persistence.nvim
-- - sindrets/diffview.nvim

local M = {}

function M.setup()
    require'config.options'

    vim.cmd'runtime config/coc.vim'

    -- require'config.lsp'
    -- require'config.completion'

    require'config.treesitter'
    require'config.telescope'
    require'config.colorscheme'
    require'config.lualine'
    require'config.lightspeed'
    require'config.tree'

    require'gitsigns'.setup {}
    -- require'trouble'.setup {}
    require'neoscroll'.setup {}
    require'specs'.setup {}
    require'colorizer'.setup {}
    require'twilight'.setup {}
    require'zen-mode'.setup {}
    require'toggleterm'.setup {}
    require'todo-comments'.setup {}

end

return M
