-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

-- to try to solve codeAction problem, I got the code snippets below:
-- (the solution was to use a properly supported fork )
-- https://github.com/glepnir/lspsaga.nvim/pull/259
-- https://github.com/tomaskallup/dotfiles/blob/master/nvim/lua/plugins/nvim-lspconfig.lua
-- https://github.com/kosayoda/nvim-lightbulb/blob/66223954d7bd7d4358c36d157c25503168d04319/lua/nvim-lightbulb.lua#L195-L201
-- https://github.com/kosayoda/nvim-lightbulb/issues/20

vim.lsp.config("bashls", {
  capabilities = capabilities,
})
vim.lsp.enable("bashls")
