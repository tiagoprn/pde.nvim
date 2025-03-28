local lspconfig = require("lspconfig")

-- set the path to the lua_ls installation
-- local lua_ls_root_path = vim.fn.expand("~/.config/nvim/lua-language-server")
-- local lua_ls_binary = lua_ls_root_path .. "/bin/lua-language-server"

-- lua language server is super confused when editing lua files in the config
-- and raises a lot of [duplicate-doc-field] warnings
local runtime_files = vim.api.nvim_get_runtime_file("", true)
for k, v in ipairs(runtime_files) do
  if v == vim.fn.expand("~/.config/nvim/after") or v == vim.fn.expand("~/.config/nvim") then
    table.remove(runtime_files, k)
  end
end

lspconfig.lua_ls.setup({
  -- cmd = { lua_ls_binary, "-E", lua_ls_root_path .. "/main.lua" },
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = true,
        -- library = {
        --   vim.env.VIMRUNTIME,
        --   -- Depending on the usage, you might want to add additional paths here.
        --   -- "${3rd}/luv/library"
        --   -- "${3rd}/busted/library",
        -- },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        library = runtime_files,
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
