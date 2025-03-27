local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "code",
      fmt(
        [[
```{}
{}
```
]],
        { i(1, "bash"), i(2) }
      )
    ),
    new_snippet(
      "today",
      f(function()
        return os.date("%Y-%m-%d")
      end)
    ),
    new_snippet(
      "hh",
      f(function()
        return os.date("%H:%M")
      end)
    ),
    new_snippet(
      "dm",
      f(function()
        return os.date("%d/%m")
      end)
    ),
    new_snippet(
      "dma",
      f(function()
        return os.date("%d/%m/%Y")
      end)
    ),
    new_snippet(
      "sig",
      fmt(
        [[
{}

---
Tiago Paranhos Lima - Senior Software Engineer (python)
https://tiagopr.nl
twitter.com/tiagoprn
]],
        { i(1) }
      )
    ),
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
    new_snippet(
      "bib-note",
      i(
        1,
        [[
---
author: "Tiago Paranhos Lima"
title: "${1}"
date: `strftime("%Y-%m-%d")`
categories: ["bibliographic-notes"]
description: "${2}"
tags: [${3:"tag1",}]
references: [${4:"link1",}]
hidden: false
draft: true
---

${4}]]
      )
    ),
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
    new_snippet(
      "recall-flashcard-new",
      i(
        1,
        [[
## Card
id: `strftime("%s")`
Q: ${1:type the question here}
A: ${2:type the answer here}
QR: ${3:type the reverse question here (turn the original answer into the question)}
AR: ${4:type the reverse answer here (turn the original question into the answer)}
Tags: ${5:tag1, tag2, ...}]]
      )
    ),
    new_snippet(
      "recall-tracking-file-entry",
      i(
        1,
        [[
## ${1: today}
- ${2: card_id, card_direction(A/AR), status, current_interval, next_review_date}]]
      )
    ),
    new_snippet(
      "recall-tracking-file",
      i(
        1,
        [[
# Tracking Journal

## Card Status Legend
- Status: EASY (21 days), GOOD (14 days), HARD (7 days), FORGOT (1 day)
- Format: id, direction(A/AR), status, current_interval, next_review_date

recall-tracking-file-entry]]
      )
    ),
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
    new_snippet(
      "journal",
      i(
        1,
        [[
---
date: `strftime("%Y-%m-%d")`
hours: [${1:"`strftime("%H:%M")`"}]
deep_work: [""]
---]]
      )
    ),
    new_snippet("journal-task-vlink", i(1, [[	r/0:00:00/vfname]])),
    new_snippet(
      "journal-task-daily",
      i(
        1,
        [[
## `strftime("%Y-%m-%d")`

### DID

TBD

### DOING

TBD

### NEXT

- [ ] ${1:"..."}
- [ ] rnote: Draw a diagram with the tables involved, if that is the case]]
      )
    ),
    new_snippet(
      "journal-task-branch",
      i(
        1,
        [[
- "${1:branch-name}" - created on `strftime("%Y-%m-%d")`, derived from "${2:derived-branch-name}" at commit "${3:derived-branch-commit-hash}" (merged into "${4:merged-branch-name}" on YYYY-MM-DD)]]
      )
    ),
    new_snippet("journal-task-pull-request", i(1, [[	- [ ] <${1:"git-pull-request-url"}>]])),
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
    new_snippet("link-markdown", i(1, [[	[${2:description}](${1:url})]])),
    new_snippet("item-markdown", i(1, [[	- [ ] ${1}]])),
    new_snippet("task_status", i(1, [[	${1|recurring,created,wip,paused,finished,archived|}]])),
    new_snippet("task_effort", i(1, [[	${1|quick-win,small,epic|}]])),
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
    new_snippet(
      "qheader",
      i(
        1,
        [[
---
created: `strftime("%Y-%m-%dT%H:%M:%S")`
modified: `strftime("%Y-%m-%dT%H:%M:%S")`
type: Journal
---

${1}]]
      )
    ),
    new_snippet(
      "book_notes_body",
      i(
        1,
        [[
# IMPRESSIONS

${1:(here is where I write dowm my feelings/impressions about the book)}

# ACTIONABLE TAKEAWAYS

${2:(maximum of 10 top main points I learned from the book that can be applied to my life/routine)}

1.

2.

3.

4.

5.

6.

7.

8.

9.

10.

# QUOTES

${3:(maximum of 5 literal quotes that I must keep as they were written, so to remember or reuse on my own future content)}

1.

2.

3.

4.

5.

# ARCHIVE **(OPTIONAL)**

${4:(on books that are so great that there are many things to remember, here go extra notes and quotes that didn't make the "top" cuts above.)}

**NOTE**: the structure used here to write this post is inspired by <https://elizabeth-filips.notion.site/>.
]]
      )
    ),
    new_snippet("gcommit", i(1, [[	feat: updated repository on `strftime("%Y-%m-%d %H:%M:%S")` ${1}]])),
    new_snippet(
      "test_report",
      i(
        1,
        [[
- timestamp: `strftime("%Y-%m-%d %H:%M:%S")`

- environment: ${1:development (my machine), ci, etc..}

- branch: \`${2}\`

- context: ${3:describe here the reason I ran the suite - e.g. after refactoring xyz}

- file: <report.txt>]]
      )
    ),
    new_snippet("prompt_code_explain", i(1, [[  Can you explain the code above to me?]])),
    new_snippet(
      "prompt_unit_test",
      i(1, [[  Can you output a unit test for the happy path on the code above using pytest?]])
    ),
    new_snippet(
      "prompt_refactor",
      i(
        1,
        [[  Can you output a refactored version of the code above, using clean code principles and summarizing what you changed?]]
      )
    ),
  },
}

return snippet
