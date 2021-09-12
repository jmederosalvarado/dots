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
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)

	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	buf_set_keymap("n", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)
	buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)

	buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

	buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", opts)
	buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)

	client.resolved_capabilities.document_formatting = false
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
			update_imports_on_move = true,
			require_confirmation_on_move = true,
			watch_dir = nil,
		})

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

local lspinstall = require("lspinstall")

local setup_servers = function()
	lspinstall.setup()
	local servers = lspinstall.installed_servers()
	table.insert(servers, "null-ls")
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
