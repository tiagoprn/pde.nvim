local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "dateobj",
      t([[
from datetime import datetime
date_obj = datetime.strptime('2011-12-31 11:59:59', '%Y-%m-%d %H:%M:%S')
]])
    ),
  },
}

return snippet
