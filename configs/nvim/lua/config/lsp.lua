require("astronauta.keymap")

-- Appearance
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = { spacing = 4, prefix = "●" },
	severity_sort = true,
	update_in_insert = true,
})

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
	local hl = "LspDiagnosticsSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

local default_on_attach = function(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.nnoremap({ "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>" }, opts)
	vim.keymap.nnoremap({ "gd", "<cmd>lua vim.lsp.buf.definition()<cr>" }, opts)
	vim.keymap.nnoremap({ "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>" }, opts)
	vim.keymap.nnoremap({ "gr", "<cmd>lua vim.lsp.buf.references()<cr>" }, opts)

	vim.keymap.nnoremap({ "K", "<cmd>lua vim.lsp.buf.hover()<cr>" }, opts)
	vim.keymap.nnoremap({ "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>" }, opts)

	vim.keymap.nnoremap({ "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>" }, opts)
	vim.keymap.nnoremap({ "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>" }, opts)
	vim.keymap.nnoremap({ "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>" }, opts)
	vim.keymap.nnoremap({ "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>" }, opts)

	vim.keymap.nnoremap({ "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>" }, opts)
	vim.keymap.nnoremap({ "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>" }, opts)

	vim.keymap.nnoremap({ "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>" }, opts)
	vim.keymap.nnoremap({ "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>" }, opts)
	vim.keymap.nnoremap({ "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>" }, opts)
	vim.keymap.nnoremap({ "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>" }, opts)
end

local server_setups = {}

-- Default {{{

server_setups["default"] = {
	on_attach = default_on_attach,
}

-- }}}

-- Lua {{{

server_setups["lua"] = require("lua-dev").setup({
	lspconfig = {
		on_attach = default_on_attach,
	},
})

-- }}}

-- Typescript & Javascript {{{

server_setups["typescript"] = {
	on_attach = function(client, bufnr)
		default_on_attach(client, bufnr)

		local ts_utils = require("nvim-lsp-ts-utils")

		-- defaults
		ts_utils.setup({
			debug = false,
			disable_commands = false,
			enable_import_on_completion = true,

			-- import all
			import_all_timeout = 5000, -- ms
			import_all_priorities = {
				buffers = 4, -- loaded buffer names
				buffer_content = 3, -- loaded buffer content
				local_files = 2, -- git files or files with relative path markers
				same_file = 1, -- add to existing import statement
			},
			import_all_scan_buffers = 100,
			import_all_select_source = false,

			-- eslint
			eslint_enable_code_actions = true,
			eslint_enable_disable_comments = true,
			eslint_bin = "eslint_d",
			eslint_config_fallback = nil,
			eslint_enable_diagnostics = true,
			eslint_show_rule_id = false,

			-- formatting
			enable_formatting = true,
			formatter = "prettierd",
			formatter_config_fallback = nil,

			-- update imports on file move
			update_imports_on_move = false,
			require_confirmation_on_move = true,
			watch_dir = nil,
		})

		client.resolved_capabilities.document_formatting = false
		-- required to fix code action ranges
		ts_utils.setup_client(client)
	end,
}

-- }}}

-- Null {{{

server_setups["null-ls"] = function()
	local null_ls = require("null-ls")
	null_ls.config({
		sources = {
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.stylua,
		},
	})
	return {
		on_attach = function(client, bufnr)
			default_on_attach(client, bufnr)
			client.resolved_capabilities.document_formatting = true
			vim.cmd("command! Format lua vim.lsp.buf.formatting_sync()")
			vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync()")
		end,
	}
end

-- }}}

local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")

if not lspconfig["vscode-solidity"] then
	configs["vscode-solidity"] = {
		default_config = {
			cmd = { "node", "/home/jmederos/src/gh/vscode-solidity/out/src/server.js", "--stdio" },
			filetypes = { "solidity" },
			root_dir = function(fname)
				return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
			end,
			settings = {},
		},
	}
end

local lspinstall = require("lspinstall")

local setup_servers = function()
	lspinstall.setup()
	local servers = lspinstall.installed_servers()
	table.insert(servers, "null-ls")
	table.insert(servers, "vscode-solidity")
	for _, server in pairs(servers) do
		local server_setup = server_setups[server] or server_setups["default"]
		local config = type(server_setup) == "function" and server_setup() or server_setup
		require("lspconfig")[server].setup(config)
	end
end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require("lspinstall").post_install_hook = function()
	setup_servers() -- reload installed servers
	vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

setup_servers()

-- vim.lsp.set_log_level("debug")
