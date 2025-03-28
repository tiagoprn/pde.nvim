local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "md5_hash",
      t([[
# Works only on strings
# To use on dicts, just use cast them to a string - str(your_dict)
import hashlib
hashlib.md5("YOUR-STRING-GOES-HERE".encode('utf-8')).hexdigest()
]])
    ),
  },
}

return snippet
