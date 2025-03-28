local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pprint_to_str",
      t([[
def custom_serializer(obj):
    from datetime import datetime
    if isinstance(obj, datetime):
        return obj.isoformat()  # Converts datetime to ISO 8601 string format
    raise TypeError(f"Type {type(obj)} not serializable")
dict_name_str = __import__('json').dumps(dict_name,
                                         indent=2,
                                         default=custom_serializer)
]])
    ),
  },
}

return snippet
