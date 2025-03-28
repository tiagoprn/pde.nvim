local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = { -- TODO: change to the snippet filetype (as known by nvim): python, lua, markdown, sh, all, etc...
    new_snippet(
      "snippet_luasnip", -- TODO: change to the snippet name
      fmt( -- TODO: change to contents of your snippet. Each {} is a placeholder for a value
        [[ This is an example luasnip snippet located at 'lua/snippets/all/template.lua'.
Copy it to 'lua/snippets/<filetype>/' and change its contents to create a new snippet.

print("DEBUG - {}: " .. {})
print("DEBUG - {}: " .. {})
print("DEBUG - {}: " .. {})
]],
        { --- TODO: change to the values on each placeholder
          i(1, "key 01"),
          i(2, "value 01"),
          i(3, "key 02"),
          i(4, "value 02"),
          i(5, "key 03"),
          i(6, "value 03"),
        }
      )
    ),
  },
}

return snippet
