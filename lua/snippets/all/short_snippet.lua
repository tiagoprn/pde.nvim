local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "short",
      i(
        1,
        [[
---
author: "Tiago Paranhos Lima"
title: "${1}"
date: `strftime("%Y-%m-%d")`
categories: ["shorts"]
description: "${2}"
tags: [${3:"tag1",}]
references: [${4:"link1",}]
hidden: false
draft: true
---

${4}]]
      )
    ),
  },
}

return snippet
