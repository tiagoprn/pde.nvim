local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

-- TypeScript Server
require("lspconfig").tsserver.setup({
  capabilities = capabilities,
  cmd = { "node", vim.fn.getcwd() .. "/node_modules/.bin/typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" },
  root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "package.json", ".git"),
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "relative",
    },
  },
})

-- HTML Server
require("lspconfig").html.setup({
  capabilities = capabilities,
  cmd = { "node", vim.fn.getcwd() .. "/node_modules/.bin/vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
  },
})

-- CSS Server
require("lspconfig").cssls.setup({
  capabilities = capabilities,
  cmd = { "node", vim.fn.getcwd() .. "/node_modules/.bin/vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss" },
  settings = {
    css = {
      validate = true,
    },
    scss = {
      validate = true,
    },
  },
})

-- ESLint using your existing installation
require("lspconfig").eslint.setup({
  capabilities = capabilities,
  cmd = {
    vim.fn.expand("~/.nvm/versions/node/v12.22.4/bin/eslint"),
    "--stdin",
    "--stdin-filename",
    "${INPUT}",
    "--format",
    "json",
  },
  filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "html" },
  root_dir = require("lspconfig.util").root_pattern(".eslintrc.js", ".eslintrc.json", "package.json"),
})
