local lsp = require("lspconfig")

-- below changes the log level of lsp, to make it more verbose so can I check its' communication with neovim.
-- The lsp log file is at ~/.local/state/nvim/lsp.log
vim.lsp.set_log_level("debug") -- change to "debug" for troubleshooting

lsp.ruff.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  cmd = { vim.fn.getenv("HOME") .. "/.pyenv/versions/neovim/bin/ruff", "server" },
  on_attach = function(client, bufnr)
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
        vim.diagnostic.enable(bufnr)
        client.request("textDocument/diagnostic", {
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
  end,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      -- change "logLevel" to "debug" below for troubleshooting
      logLevel = "debug",
      logFile = vim.fn.getenv("HOME") .. "/.local/state/nvim/ruff.log",
      args = {},
    },
  },
  single_file_support = true,
})
