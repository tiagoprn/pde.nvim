local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "ifmain",
      fmt(
        [[
if __name__ == '__main__':
    {}{}
]],
        {
          i(1, "main()"),
          i(0, ""),
        }
      )
    ),
  },
}

return snippet
