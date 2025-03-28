local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "zettelkasten",
      i(
        1,
        [[
---
title: "${1}"
date: `strftime("%Y-%m-%d %H:%M:%S")`
tags: [${2:"tag1",}]
links: [${3}]
---

${4}]]
      )
    ),
  },
}

return snippet
