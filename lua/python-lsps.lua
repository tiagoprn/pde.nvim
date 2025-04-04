local lsp = require("lspconfig")

local LOG_LEVEL = "warn" -- change to "debug" here for troubleshooting

-- below changes the log level of lsp, to make it more verbose so can I check its' communication with neovim.
vim.lsp.set_log_level(LOG_LEVEL)

-- USE THIS COMMAND on a python file to validate it is working: `checkhealth lsp`

-- Below customizes how diagnostics are shown
vim.diagnostic.config({
  -- Enable INLINE diagnostic details
  --
  -- IMPORTANT: there is a NORMAL MODE mapping on lua/key-mappings-conf.lua that expands
  --            the diagnostics details into virtual lines with <C-k>
  --
  virtual_text = {
    prefix = "●", -- You can choose any symbol or string
    format = function(diagnostic)
      return string.format("%s [%s]", diagnostic.message, diagnostic.source)
    end,
  },

  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Hide diagnostics when entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.diagnostic.hide(nil, 0) -- hides diagnostics for the current buffer (id 0)
  end,
})

-- Show diagnostics when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.diagnostic.show(nil, 0) -- shows diagnostics for the current buffer
  end,
})

lsp.jedi_language_server.setup({
  capabilities = (function()
    local cap = vim.lsp.protocol.make_client_capabilities()
    cap = vim.tbl_deep_extend("force", cap, require("blink.cmp").get_lsp_capabilities({}, false))
    return cap
  end)(), -- Execute the function immediately to return the capabilities table
  cmd = {
    vim.fn.getenv("HOME") .. "/.pyenv/versions/neovim/bin/jedi-language-server",
    -- "-v",
    "--log-file",
    vim.fn.getenv("HOME") .. "/.local/share/nvim/jedi-lsp-server.log",
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

lsp.ruff.setup({
  offset_encoding = "utf-16", -- forces ruff to use UTF-16
  init_options = {
    settings = { -- https://docs.astral.sh/ruff/editors/settings/#settings
      -- configuration = "~/path/to/ruff.toml",  -- https://docs.astral.sh/ruff/configuration/
      lineLength = 100,
      organizeImports = true,
      showSyntaxErrors = true,
      configurationPreference = "editorOnly", -- https://docs.astral.sh/ruff/editors/settings/#configurationpreference
      -- Any extra CLI arguments for `ruff` go here.
      logLevel = LOG_LEVEL,
      logFile = vim.fn.getenv("HOME") .. "/.local/share/nvim/ruff-lsp-server.log",
      args = {},
      lint = {
        select = { --  https://docs.astral.sh/ruff/settings/#lint_select
          -- -- Below are the defaults
          "E4",
          "E7",
          "E9",
          "F",
          "W",
          -- -- Below are additional ones
          "E401", -- Multiple imports on one line
          "E402", -- Module level import not at top of file
          "E501", -- line too long (> 79 characters)
          "F401", -- '____' imported but unused
          "F522", -- `.format` call has unused named argument(s): name
          "F541", -- f-string without any placeholders
          "E703", -- Statement ends with an unnecessary semicolon
          "E711", -- comparison to None should be 'if cond is not None:'
          "E712", -- comparison to True should be 'if cond is True:' or 'if cond:'
          "E713", -- Test for membership should be
          "E722", -- do not use bare 'except'
          "E721", -- Do not compare types, use `isinstance()`
          "E731", -- do not assign a lambda expression, use a def
          "E741", -- Ambiguous variable name
          "F523", -- `.format` call has unused arguments at position(s)
          "F524", -- `.format` call is missing argument(s) for placeholder(s)
          "F632", -- use '__' to compare constant literals
          "F811", -- Redefinition of unused ...
          "F821", -- Undefined name
          "F841", -- local variable 'exc' is assigned to but never used
        },
        ignore = { -- https://docs.astral.sh/ruff/settings/#lint_ignore
          -- -- IN "PREVIEW" MODE, so still experimental/unstable: (last check on ruff 0.11.2)
          -- "E302",
          -- "E303",
          -- "E252",
          -- -- NOT SUPPORTED: (last check on ruff 0.11.2)
          -- "E121", -- continuation line under-indented for hanging indent
          -- "E122", -- continuation line missing indentation or outdented
          -- "E123", -- closing bracket does not match indentation of opening bracket's line
          -- "E124", -- closing bracket does not match visual indentation
          -- "E125", -- continuation line with same indent as next logical line
          -- "E126", -- continuation line over-indented for hanging indent
          -- "E127", -- continuation line over-indented for visual indent
          -- "E128", -- continuation line under-indented for visual indent
          -- "E131", -- continuation line unaligned for hanging indent
          -- "W503", -- line break before binary operator
          -- "W504", -- line break after binary operator
        },
      },
    },
  },
  capabilities = (function()
    local cap = vim.lsp.protocol.make_client_capabilities()

    cap = vim.tbl_deep_extend("force", cap, require("blink.cmp").get_lsp_capabilities({}, false))

    cap = vim.tbl_deep_extend("force", cap, {
      offsetEncoding = { "utf-16" },
      general = {
        positionEncodings = { "utf-16" },
      },
    })
    return cap
  end)(),
  cmd = { vim.fn.getenv("HOME") .. "/.pyenv/versions/neovim/bin/ruff", "server" },
  on_attach = function(client, bufnr)
    -- NOTE: do not enable full file automatic formatting on save because of existing codebases
    client.server_capabilities.document_formatting = false

    client.server_capabilities.document_range_formatting = true
    client.server_capabilities.document_diagnostics = true

    -- Enable file watching
    client.server_capabilities.workspace = client.server_capabilities.workspace or {}
    client.server_capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }

    -- Create autocmds to control when diagnostics run
    -- Hide diagnostics in insert mode
    vim.api.nvim_create_autocmd("InsertEnter", {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.hide(bufnr) -- Changed from disable(bufnr) to hide(bufnr)
      end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.show(bufnr)

        -- Force refresh diagnostics with a simpler approach
        vim.schedule(function()
          -- Get the document URI
          local uri = vim.uri_from_bufnr(bufnr)

          -- Request diagnostics directly without sending didChange
          client.request("textDocument/diagnostic", {
            textDocument = { uri = uri },
          }, nil, bufnr)
        end)
      end,
    })

    vim.api.nvim_create_autocmd({
      "BufEnter",
      "BufWritePost",
    }, {
      buffer = bufnr,
      callback = function()
        if vim.api.nvim_get_mode().mode ~= "i" then -- Only if not in insert mode
          vim.diagnostic.show(bufnr)

          -- Force refresh diagnostics with a simpler approach
          vim.schedule(function()
            -- Get the document URI
            local uri = vim.uri_from_bufnr(bufnr)

            -- Request diagnostics directly without sending didChange
            client.request("textDocument/diagnostic", {
              textDocument = { uri = uri },
            }, nil, bufnr)
          end)
        end
      end,
    })

    -- mapping to force ruff diagnostics manually
    vim.keymap.set("n", "<leader>cR", function()
      vim.diagnostic.show(bufnr)
      local uri = vim.uri_from_bufnr(bufnr)
      client.request("textDocument/diagnostic", {
        textDocument = { uri = uri },
      }, nil, bufnr)
      vim.notify("Ruff diagnostics refreshed")
    end, { buffer = bufnr, desc = "ruff: refresh diagnostics" })

    -- mapping to format the selection with ruff
    vim.keymap.set("v", "<leader>cf", function()
      vim.lsp.buf.format({
        async = true,
        range = {
          ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
          ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
      })
    end, { buffer = bufnr, desc = "ruff: format selection" })

    -- mapping to format the whole file with ruff
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({
        async = true,
      })

      vim.notify("ruff: buffer successfully formatted")
    end, { buffer = bufnr, desc = "ruff: format whole buffer" })
  end,
  single_file_support = true,
})
