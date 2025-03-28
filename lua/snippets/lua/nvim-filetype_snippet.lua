local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "nvim-filetype",
      t([[
local filetype = vim.bo.filetype]])
    ),
  },
}

return snippet
