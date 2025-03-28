local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "function_info",
      t([[
# fun below can be any function object.
# e.g. fun = print
info = f'module: {fun.__module__} , name: {fun.__qualname__}'
print(info)
]])
    ),
  },
}

return snippet
