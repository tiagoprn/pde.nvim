local lspconfig = require("lspconfig")

-- Configuration for lua_ls (Lua language server)
lspconfig.lua_ls.setup({
  single_file_support = true,
  -- Force single file mode
  root_dir = function(fname)
    return nil -- Forces single file mode by not finding a root
  end,
  on_init = function(client)
    -- Limit workspace folders to just the current file's directory
    client.config.capabilities = client.config.capabilities or vim.lsp.protocol.make_client_capabilities()
    client.config.capabilities.workspace = client.config.capabilities.workspace or {}
    client.config.capabilities.workspace.workspaceFolders = false
    client.config.capabilities.workspace.fileOperations = {
      didCreate = false,
      willCreate = false,
      didRename = false,
      willRename = false,
      didDelete = false,
      willDelete = false,
    }

    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    -- Apply these settings to fix the "Undefined global 'vim'" error
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = "LuaJIT",
      },
      diagnostics = {
        -- Recognize the `vim` global
        globals = {
          "vim",
          -- Add other globals if needed
          "awesome",
          "client",
          "root",
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          -- This is the key part: include the Neovim API in library
          vim.api.nvim_get_runtime_file("", true),
          "${3rd}/luv/library",
        },
        checkThirdParty = false, -- Disable annoying prompts
        -- -- Limit workspace scope
        -- maxPreload = 0,
        -- preloadFileSize = 0,
        -- ignoreSubmodules = true,
      },
      telemetry = {
        enable = false,
      },
      completion = {
        callSnippet = "Replace",
      },
    })
  end,
  settings = {
    Lua = {
      workspace = {
        -- Additional workspace limitations
        ignoreDir = vim.fn.getcwd(), -- Ignore the workspace root directory
        maxPreload = 0, -- Disable preloading
        preloadFileSize = 0, -- Disable preloading
      },
    },
  },
})
