local lsp = require("lspconfig")

-- below changes the log level of lsp, to make it more verbose so can I check its' communication with neovim.
-- The lsp log file is at ~/.local/share/nvim/lsp.log
vim.lsp.set_log_level("debug") -- change to "debug" for troubleshooting

-- assumes python-language-server[all] installed from pip
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
  init_options = {
    settings = { -- https://docs.astral.sh/ruff/editors/settings/#settings
      -- configuration = "~/path/to/ruff.toml",  -- https://docs.astral.sh/ruff/configuration/
      lineLength = 100,
      organizeImports = true,
      showSyntaxErrors = true,
      configurationPreference = "filesystemFirst", -- https://docs.astral.sh/ruff/editors/settings/#configurationpreference
    },
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
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

    -- Optional: Show diagnostics in a floating window on cursor hover
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = "always",
          scope = "cursor",
        })
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

      vim.api.nvim_echo({ { "ruff: buffer successfully formatted!", "WarningMsg" } }, true, {})
    end, { buffer = bufnr, desc = "Format whole buffer with Ruff" })
  end,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      -- change "logLevel" to "debug" below for troubleshooting
      logLevel = "debug",
      logFile = vim.fn.getenv("HOME") .. "/.local/share/nvim/ruff.log",
      args = {},
    },
  },
  single_file_support = true,
})
