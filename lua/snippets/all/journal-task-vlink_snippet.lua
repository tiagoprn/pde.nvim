local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet("journal-task-vlink", i(1, [[	<r/0:00:00/vfname>]])),
  },
}

return snippet
