local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "task",
      i(
        1,
        [[
---
goal: "${1:Goal}"
created: "`strftime("%Y-%m-%d %H:%M:%S")`"
closed: ""
effort: "task_effort"
current_status: "task_status"
tags: []
---

# DESCRIPTION

${2:What needs to be done?}


# CHECKLIST

journal-task-daily


# REFERENCES

N/A


# TECHNICAL CONTEXT

N/A


# TECHNICAL DISCOVERY

N/A]]
      )
    ),
  },
}

return snippet
