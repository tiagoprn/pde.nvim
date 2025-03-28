local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "journal-task",
      i(
        1,
        [[
---
title: "${1}"
date: `strftime("%Y-%m-%d %H:%M:%S")`
due_at: ""
started_at: "timestamp"
closed_at: "timestamp"
tags: [${2:"tag1",}]
links: []
---

# CONTEXT

TBD

# TECHNICAL DISCOVERY

TBD

# REFERENCES

TBD

# DAILY JOURNAL

journal-task-daily

# POSTMORTEM

- yyyy-mm-dd: (write bullet points here when I reached a road block or something that stopped or slowed my code today - be as technical as needed)

# BRANCHES

journal-task-branch

# PULL REQUESTS

journal-task-pull-request]]
      )
    ),
  },
}

return snippet
