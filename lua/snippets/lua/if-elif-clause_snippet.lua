local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "if-elif-clause",
      fmt(
        [[
elseif {} then
  {}]],
        { i(1, "condition"), i(0, "--body") }
      )
    ),
  },
}

return snippet
