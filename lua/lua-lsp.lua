-- This plugin is not installed anymore, it was changed for lazydev.nvim
-- because it was deprecated. I only kept this file in case I need something
-- here to customize lazydev.nvim.

require("neodev").setup({
	-- https://github.com/folke/neodev.nvim#-setup
	-- add any options here, or leave empty to use the default settings
})

-- set the path to the lua_ls installation
local lua_ls_root_path = vim.fn.expand("~/.config/nvim/lua-language-server")
local lua_ls_binary = lua_ls_root_path .. "/bin/lua-language-server"

-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
	cmd = { lua_ls_binary, "-E", lua_ls_root_path .. "/main.lua" },
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
			client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							-- vim.env.VIMRUNTIME,
							vim.fn.expand("$VIMRUNTIME/lua"),
							vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
							vim.fn.stdpath("config") .. "/lua",
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				},
			})

			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
})
