-- assumes python-language-server[all] installed from pip
local lsp = require("lspconfig")

-- lsp.pylsp.setup({
-- 	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
-- 	cmd = { vim.fn.getenv("HOME") .. "/.pyenv/versions/neovim/bin/pylsp" },
-- 	-- disabled formatting capabilities because they are provided py
-- 	-- null-ls, which has configuration for all languages.
-- 	on_attach = function(client, bufnr)
-- 		client.server_capabilities.document_formatting = false
-- 		client.server_capabilities.document_range_formatting = false
-- 		client.server_capabilities.document_diagnostics = false
-- 	end,
-- 	settings = {
-- 		pylsp = {
-- 			-- disabling below because I use null-ls for that
-- 			plugins = {
-- 				pyflakes = { enabled = false },
-- 				flake8 = { enabled = false },
-- 				pylint = { enabled = false },
-- 				isort = { enabled = false },
-- 				pycodestyle = { enabled = false },
-- 			},
-- 		},
-- 	},
-- })

lsp.jedi_language_server.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	cmd = {
		vim.fn.getenv("HOME") .. "/.pyenv/versions/neovim/bin/jedi-language-server",
		-- "-v",
		"--log-file",
		vim.fn.getenv("HOME") .. "/.local/state/nvim/lsp.log",
	},

	root_dir = require("lspconfig/util").root_pattern(".git"),
	-- disabled formatting capabilities because they are provided py
	-- null-ls, which has configuration for all languages.
	on_attach = function(client, bufnr)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
		client.server_capabilities.document_diagnostics = false
	end,
	settings = { -- below was generated with ChatGPT. I asked it to generate with the default values to see all available options.
		jedi = {
			-- completion = {
			-- 	fuzzy = true, -- Enable fuzzy completions
			-- 	show_doc_strings = true, -- Show doc strings in completions
			-- },
			diagnostics = {
				enable = false, -- Enable or disable diagnostics as you type
				-- did_open = true, -- Run diagnostics on open
				-- did_change = true, -- Run diagnostics on change
				-- did_save = true, -- Run diagnostics on save
			},
			-- environment = nil, -- The virtual environment to use for Jedi. Set to a path if you want a specific one, else nil
			-- extra_paths = { "watson" }, -- Additional sys paths for Jedi to explore
			references = {
				extra_params = {}, -- Extra parameters for finding references, empty by default
			},
			signatures = {
				show_doc_strings = true, -- Show doc strings in function signatures/help
			},
			workspace = {
				extra_params = {}, -- Extra parameters for the workspace
			},
		},
	},
})
