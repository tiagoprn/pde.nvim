local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet("journal-task-pull-request", i(1, [[	- [ ] <${1:"git-pull-request-url"}>]])),
  },
}

return snippet
