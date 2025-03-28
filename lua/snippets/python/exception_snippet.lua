local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "exception",
      fmt(
        [[
try:
    {}
except:
    logging.exception({})
]],
        {
          i(1, "code"),
          i(2, "message"),
        }
      )
    ),
  },
}

return snippet
