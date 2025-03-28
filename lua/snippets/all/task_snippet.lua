local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "task",
      fmt(
        [[
---
goal: "{}"
created: "{}"
closed: ""
effort: "task_effort"
current_status: "task_status"
tags: []
---

# DESCRIPTION

{}


# CHECKLIST

journal-task-daily


# REFERENCES

N/A


# TECHNICAL CONTEXT

N/A


# TECHNICAL DISCOVERY

N/A]],
        {
          i(1, "Goal"),
          f(function()
            return os.date("%Y-%m-%d %H:%M:%S")
          end),
          i(2, "What needs to be done?"),
        }
      )
    ),
  },
}

return snippet
