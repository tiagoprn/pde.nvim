local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "debug_lua_object_or_table",
      fmt(
        [[
print(vim.inspect({}))]],
        { i(1, "object_or_table") }
      )
    ),
  },
}

return snippet
