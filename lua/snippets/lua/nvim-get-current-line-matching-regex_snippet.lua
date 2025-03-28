local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "nvim-get-current-line-matching-regex",
      t([[
vim.fn.getline("."):match("amazing")]])
    ),
  },
}

return snippet
