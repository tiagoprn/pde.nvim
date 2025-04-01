local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    border = "double",
    -- max_width = 100,
    max_width = math.floor(vim.o.columns * 0.7),
    max_height = math.floor(vim.o.lines * 0.7),
  })
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  title = "Signature help",
  border = "double",
  title_pos = "left",
  -- max_width = 100,
  max_width = math.floor(vim.o.columns * 0.4),
  max_height = math.floor(vim.o.lines * 0.5),
})
