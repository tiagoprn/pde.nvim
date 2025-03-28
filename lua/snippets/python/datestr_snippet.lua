local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "datestr",
      t({
        "from datetime import datetime",
        "date_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')",
      })
    ),
  },
}

return snippet
