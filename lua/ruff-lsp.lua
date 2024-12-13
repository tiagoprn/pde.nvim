local lsp = require("lspconfig")
local helpers = require("tiagoprn.helpers")

lsp.ruff.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  cmd = {
    vim.fn.getenv("HOME") .. "/.pyenv/versions/neovim/bin/ruff-lsp",
    -- .. " --config="
    -- .. helpers.get_pyproject_toml_path(),
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
    client.server_capabilities.document_diagnostics = true
  end,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
})
