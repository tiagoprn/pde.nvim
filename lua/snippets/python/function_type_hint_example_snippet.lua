local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "function_type_hint_example",
      t([[
from typing import Callable
GreetingReader = Callable[[], str]
#                         |   |
#                         |   |> return value
#                         |
#                         |> arguments
]])
    ),
  },
}

return snippet
