-- # Plugins to check out
--   - akinsho/nvim-bufferline.lua
--   - welle/targets.vim (and other text-object related)
--   - andymass/vim-matchup
--   - iamcco/markdown-preview.nvim & npxbr/glow.nvim & plasticboy/vim-markdown
--   ----------------------------------------------------
--   - jose-elias-alvarez/null-ls.nvim
--   - something for formatting (maybe null-ls)
--   - simrat39/symbols-outline.nvim
--   - simrat39/rust-tools.nvim
--   - glepnir/dashboard-nvim
--   - norcalli/nvim-terminal.lua
--   - windwp/nvim-spectre
--   - kyazdani42/nvim-tree.lua
--   - akinsho/nvim-toggleterm.lua
--   - folke/persistence.nvim
--   - sindrets/diffview.nvim

local use_config = function(config)
    return string.format([[require'utils'.load'%s']], config)
end

local use_setup = function(name)
    return string.format([[require'%s'.setup {}]], name)
end

local plugins = function(use)
    use 'wbthomason/packer.nvim'

    -- lsp & completion {{{

    use {
        'neovim/nvim-lspconfig',
        requires = {
            'folke/lua-dev.nvim'
        },
        config = use_config 'config.lsp'
    }

    use {
        'hrsh7th/nvim-compe',
        requires = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        config = use_config 'config.compe',
    }

    use {
        'folke/trouble.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = use_setup 'trouble'
    }

    -- }}}

    -- treesitter {{{

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = { 'nvim-treesitter/playground' },
        config = use_config 'config.treesitter'
    }

    -- }}}

    -- version contron (aka. git) {{{

    use 'tpope/vim-fugitive'
    use {
        'TimUntersberger/neogit',
        requires = 'nvim-lua/plenary.nvim'
    }
    use {
      -- TODO
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = use_setup 'gitsigns'
    }


    -- fuzzy finder {{{

    use {
        'nvim-telescope/telescope.nvim',
        config = use_config 'config.telescope',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            -- optional
            'kyazdani42/nvim-web-devicons',
        }
    }

    -- }}}

    -- appearance {{{

    use {
        'Luxed/ayu-vim',
        config = function()
            vim.g.ayucolor = 'mirage'
            vim.o.background = 'dark'
            vim.cmd 'colorscheme ayu'
        end
    }
    use {
        'hoob3rt/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = use_config 'config.lualine'
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
        'lukas-reineke/indent-blankline.nvim',
        disable = true
    }
    use {
        'folke/twilight.nvim',
        config = use_setup 'twilight'
    }
    use {
        'folke/zen-mode.nvim',
        config = use_setup 'zen-mode',
        requires = {
            'folke/twilight.nvim'
        }
    }

    -- misc {{{

    use 'tpope/vim-vinegar'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'mbbill/undotree'
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require'nvim-autopairs'.setup()
            require("nvim-autopairs.completion.compe").setup({
                map_cr = true, --  map <CR> on insert mode
                map_complete = true -- it will auto insert `(` after select function or method item
            })
        end
    }
    use {
        'folke/todo-comments.nvim',
        config = function ()
            require'todo-comments'.setup {
                keywords = {
                    TODO = {
                        alt = { "WIP" }
                    }
                }
            }
        end
    }
    use {
        'norcalli/nvim-colorizer.lua',
        config = use_setup 'colorizer'
    }
    use {
        'ggandor/lightspeed.nvim',
        config = use_config 'config.lightspeed'
    }

    -- }}}
end


require'packer'.startup({ plugins, config = {
    display = {
        open_fn = function ()
            return require'packer.util'.float({ border = 'single' })
        end
    }
}})
