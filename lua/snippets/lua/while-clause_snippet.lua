local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "while-clause",
      fmt(
        [[
while {} do
  {}
end]],
        { i(1, "condition"), i(0, "--body") }
      )
    ),
  },
}

return snippet
