local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "class",
      fmt(
        [[
class {}({}):
    """{}"""
    def __init__(self, {}):
        {}
        self.{} = {}
        {}
]],
        {
          i(1, "ClassName"),
          i(2, "object"),
          i(3, "docstring for ClassName"),
          i(4, "arg"),
          i(5, "super(ClassName, self).__init__()"),
          i(6, "arg"),
          i(7, "arg"),
          i(8, ""),
        }
      )
    ),
  },
}

return snippet
