local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "current-date",
      t([[
local current_date = os.date("%Y-%m-%d-%H%M%S")]])
    ),
  },
}

return snippet
