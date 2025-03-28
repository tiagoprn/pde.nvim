local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet("gcommit", i(1, [[	feat: updated repository on `strftime("%Y-%m-%d %H:%M:%S")` ${1}]])),
  },
}

return snippet
