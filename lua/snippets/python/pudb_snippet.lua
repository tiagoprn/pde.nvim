local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pudb",
      t([[
__import__('pudb').set_trace()
]])
    ),
  },
}

return snippet
