local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

local snippet = {
  python = {
    new_snippet(
      "exception_print_traceback",
      fmta(
        [[
try:
    <>
except Exception as ex:
    message = f'Exception happened. Traceback: {traceback.format_exc()}'
    print(message)
]],
        {
          i(1, ""),
        }
      )
    ),
  },
}

return snippet
