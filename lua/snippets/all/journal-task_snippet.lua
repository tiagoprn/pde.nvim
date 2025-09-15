local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function get_current_timestamp()
  return os.date("%Y-%m-%d %H:%M:%S")
end

local snippet = {
  all = {
    new_snippet(
      "journal-task",
      fmt(
        [[
---
title: "{}"
date: {}
due_at: ""
started_at: "timestamp"
closed_at: "timestamp"
tags: [{}]
links: []
---

# POSTMORTEM

- yyyy-mm-dd: (write bullet points here when I reached a road block or something that stopped or slowed my code today - be as technical as needed)

# CONTEXT

TBD

# REFERENCES

TBD

# PULL REQUESTS

journal-task-pull-request

# BRANCHES

journal-task-branch

# TECHNICAL DISCOVERY

TBD

# DAILY JOURNAL

journal-task-daily

]],
        {
          i(1, ""),
          f(function()
            return get_current_timestamp()
          end),
          i(2, '"tag1",'),
        }
      )
    ),
  },
}

return snippet
