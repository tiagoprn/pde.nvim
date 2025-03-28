local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "flashcard_writeloop",
      i(
        1,
        [[
---
author: "Tiago Paranhos Lima"
title: "${1}"
date: "$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE"
categories: ["flashcards"]
tags: [${2:"tag1",}]
references: [${3:"link1",}]
hidden: false
draft: true
---

${4}]]
      )
    ),
  },
}

return snippet
