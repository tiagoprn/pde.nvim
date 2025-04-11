local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

-- Path to a newer Node.js version that supports optional chaining
local node_path = vim.fn.expand("~/.nvm/versions/node/v14.17.0/bin/node")
-- If you don't have v14.17.0 installed, use any version >= 14
-- You can check available versions with: ls ~/.nvm/versions/node/

-- TypeScript Server
require("lspconfig").tsserver.setup({
  capabilities = capabilities,
  cmd = { node_path, vim.fn.getcwd() .. "/node_modules/typescript-language-server/lib/cli.js", "--stdio" },
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
  cmd = { node_path, vim.fn.getcwd() .. "/node_modules/vscode-html-languageserver-bin/htmlServerMain.js", "--stdio" },
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
  cmd = { node_path, vim.fn.getcwd() .. "/node_modules/vscode-css-languageserver-bin/cssServerMain.js", "--stdio" },
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
