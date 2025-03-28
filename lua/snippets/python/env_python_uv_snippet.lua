local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "env_python_uv",
      t([[
#!/usr/bin/env -S uv run --script
]])
    ),
  },
}

return snippet
