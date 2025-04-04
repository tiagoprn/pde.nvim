local lsp = require("lspconfig")

-- below changes the log level of lsp, to make it more verbose so can I check its' communication with neovim.
-- vim.lsp.set_log_level("debug") -- change to "debug" for troubleshooting

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
    vim.fn.getenv("HOME") .. "/.local/share/nvim/lsp.log",
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
      configurationPreference = "filesystemFirst", -- https://docs.astral.sh/ruff/editors/settings/#configurationpreference
      -- Any extra CLI arguments for `ruff` go here.
      -- change "logLevel" to "debug" below for troubleshooting
      logLevel = "debug",
      logFile = vim.fn.getenv("HOME") .. "/.local/share/nvim/ruff.log",
      args = {},
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

    -- Request diagnostics when I open the file (and do other buffer/window/tab events) explicitly.
    -- Otherwise it does not show after I open it, just if a reload it.
    vim.api.nvim_create_autocmd({
      "BufEnter",
      "BufWritePost",
      "WinEnter",
      "WinNew",
      "BufWinEnter",
      "TabEnter",
      "BufReadPost",
    }, {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.enable(true, { buffer = bufnr })
        client:request("textDocument/diagnostic", {
          textDocument = vim.lsp.util.make_text_document_params(bufnr),
        }, nil, bufnr)
      end,
    })

    -- mapping to format the selection with ruff
    vim.keymap.set("v", "<leader>cf", function()
      vim.lsp.buf.format({
        async = true,
        range = {
          ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
          ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
      })
    end, { buffer = bufnr, desc = "Format selection with Ruff" })

    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({
        async = true,
      })

      vim.cmd('echomsg "ruff: buffer successfully formatted!"')
    end, { buffer = bufnr, desc = "Format whole buffer with Ruff" })
  end,
  single_file_support = true,
})
