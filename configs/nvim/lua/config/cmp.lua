local cmp = require("cmp")
local types = require("cmp.types")
local luasnip = require("luasnip")

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	preselect = types.cmp.PreselectMode.Item,

	confirmation = {
		default_behavior = types.cmp.ConfirmBehavior.Insert,
		get_commit_characters = function(commit_characters)
			return commit_characters
		end,
	},

	event = {},

	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t("<C-n>"), "n")
			elseif luasnip.expand_or_jumpable() then
				vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t("<C-p>"), "n")
			elseif luasnip.jumpable(-1) then
				vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},

	formatting = {
		deprecated = true,
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				buffer = "[Buffer]",
				path = "[Path]",
				-- nvim_lua = "[Lua]",
				-- latex_symbols = "[Latex]",
			})[entry.source.name]
			return vim_item
		end,
	},

	experimental = {
		ghost_text = true,
	},

	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

-- FIXME: luasnip/loaders/from_vscode.lua:121: attempt to call global 'filter_list' (a nil value)
-- require("luasnip.loaders.from_vscode").lazy_load()

require("nvim-autopairs").setup({ check_ts = true })
require("nvim-autopairs.completion.cmp").setup({
	map_cr = true, --  map <CR> on insert mode
	map_complete = true, -- it will auto insert `(` after select function or method item
	auto_select = true, -- automatically select the first item
})
