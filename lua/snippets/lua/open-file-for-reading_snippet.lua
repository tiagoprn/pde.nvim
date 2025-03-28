local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "open-file-for-reading",
      fmt(
        [[
local file = io.open({}, "r")
local lines = file:read("*all")
file:close()]],
        { i(1, "file_path") }
      )
    ),
  },
}

return snippet
