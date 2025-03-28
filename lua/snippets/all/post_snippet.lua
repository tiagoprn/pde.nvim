local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "post",
      fmt(
        [[
---
author: "Tiago Paranhos Lima"
title: "{}"
date: {}
description: "{}"
tags: [{}]
references: [{}]
hidden: false
draft: true
---

{}
]],
        {
          i(1),
          f(function()
            return os.date("%Y-%m-%d")
          end),
          i(2),
          i(3, '"tag1"'),
          i(4, '"link1"'),
          i(5),
        }
      )
    ),
  },
}

return snippet
