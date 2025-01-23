local lsp = require("lspconfig")

vim.lsp.set_log_level("debug")

lsp.ruff.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  cmd = { vim.fn.getenv("HOME") .. "/.pyenv/versions/neovim/bin/ruff", "server" },
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = true
    client.server_capabilities.document_diagnostics = true
  end,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      logLevel = "debug",
      logFile = vim.fn.getenv("HOME") .. "/.local/state/nvim/ruff.log",
      args = {},
    },
  },
  single_file_support = true,
})
