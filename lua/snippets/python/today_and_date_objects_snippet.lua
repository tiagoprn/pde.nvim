local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "today_and_date_objects",
      t([[
from datetime import datetime
today = datetime.today().date()  # this returns a date (not datetime) object
date_object = datetime(2023, 12, 31).date()  # this builds a date (not datetime) object, that can be compared with "today" above
]])
    ),
  },
}

return snippet
