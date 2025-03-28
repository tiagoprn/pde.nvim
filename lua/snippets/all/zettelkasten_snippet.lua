local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "zettelkasten",
      fmt(
        [[
---
title: "{}"
date: {}
tags: [{}]
links: [{}]
---

{}]],
        {
          i(1, ""),
          f(function()
            return os.date("%Y-%m-%d %H:%M:%S")
          end),
          i(2, '"tag1",'),
          i(3, ""),
          i(4, ""),
        }
      )
    ),
  },
}

return snippet
