local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet("task_effort", i(1, [[	${1|quick-win,small,epic|}]])),
  },
}

return snippet
