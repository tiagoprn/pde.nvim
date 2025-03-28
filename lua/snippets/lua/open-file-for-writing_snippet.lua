local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "open-file-for-writing",
      fmt(
        [[
local file = io.open({}, "a")
io.output(file)
io.write({})
io.close(file)]],
        { i(1, "file_path"), i(2, "content") } -- Added the missing second placeholder
      )
    ),
  },
}

return snippet
