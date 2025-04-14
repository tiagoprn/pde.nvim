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

-- The configuration below is NOT using an LSP.
-- Since I had the lsp configured correctly for eslint but it did not attach or show correctly
-- in the buffer as ts_ls does, I decided to create a custom nvim command to trigger it when saving
-- a ts/js buffer.

vim.api.nvim_create_user_command("ESLintDiagnostics", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  -- Use vim.fn.expand for the paths
  local eslint_path = vim.fn.expand("~/.nvm/versions/node/v12.22.4/bin/eslint")
  local cmd = string.format("%s --format json %s", eslint_path, vim.fn.shellescape(filename))

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data or #data == 0 or not data[1] or data[1] == "" then
        return
      end

      local results = vim.fn.json_decode(table.concat(data, "\n"))
      local diagnostics = {}

      for _, result in ipairs(results) do
        for _, problem in ipairs(result.messages) do
          table.insert(diagnostics, {
            lnum = problem.line - 1,
            col = problem.column - 1,
            message = problem.message,
            severity = problem.severity == 2 and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
            source = "eslint",
          })
        end
      end

      -- Create a dedicated namespace for ESLint diagnostics
      local ns = vim.api.nvim_create_namespace("eslint_diagnostics")
      vim.diagnostic.set(ns, bufnr, diagnostics)
      print("ESLint diagnostics updated: " .. #diagnostics .. " issues found")
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        print("ESLint error: " .. table.concat(data, "\n"))
      end
    end,
  })
end, {})

-- Command to clear ESLint diagnostics
vim.api.nvim_create_user_command("ESLintClear", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ns = vim.api.nvim_create_namespace("eslint_diagnostics")
  vim.diagnostic.reset(ns, bufnr)
  print("ESLint diagnostics cleared")
end, {})

-- Command to automatically run ESLint on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    vim.cmd("ESLintDiagnostics")
  end,
})
