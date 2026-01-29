-- Refactored for Neovim 0.11 using vim.lsp.config
local lsp_name = "lua_ls"

vim.lsp.config[lsp_name] = {
  -- Single file support - don't look for root directory
  root_dir = function(_fname)
    return nil
  end,

  -- Settings for the language server
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        -- Ignore the workspace root directory
        ignoreDir = vim.fn.getcwd(),
        maxPreload = 0,
        preloadFileSize = 0,
      },
      telemetry = {
        enable = false,
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },

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
      diagnostics = {
        -- Recognize the `vim` global
        globals = {
          "vim",
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
      },
    })
  end,
}

-- Register the language server
vim.lsp.config.register(lsp_name)
