vim.o.completeopt = 'menuone,noselect'

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;

    luasnip = true;
  };
}

require'luasnip.loaders.from_vscode'.load()

require'nvim-autopairs'.setup {
    check_ts = true
}
require'nvim-autopairs.completion.compe'.setup {
    map_cr = true,
    map_complete = true
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif require'luasnip'.expand_or_jumpable() == 1 then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif require'luasnip'.jumpable(-1) == 1 then
    return t '<Plug>luasnip-jump-prev'
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap('i', '<C-Space>', [[compe#complete()]],
    { silent = true, expr = true, noremap = true })
-- vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]],
--     { silent = true, expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<C-e>', [[compe#close('<C-e>')]],
    { silent = true, expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
