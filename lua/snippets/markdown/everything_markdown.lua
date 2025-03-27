local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Includes octopress (http://octopress.org/) snippets
-- The suffix `c` stands for "Clipboard".

local snippet = {
  markdown = {
    -- Basic link
    new_snippet(
      "[",
      fmt(
        [[
[{}](https://{})
]],
        {
          i(1, "text"),
          i(2, "address"),
        }
      )
    ),

    -- Link with clipboard
    new_snippet(
      "[*",
      fmt(
        [[
[{}]({})
]],
        {
          i(1, "link"),
          i(2, "`@*`"),
        }
      )
    ),

    new_snippet(
      "[c",
      fmt(
        [[
[{}]({})
]],
        {
          i(1, "link"),
          i(2, "`@+`"),
        }
      )
    ),

    -- Link with title - use different names to avoid issues with quotes
    new_snippet(
      "[t",
      fmt(
        [[
[{}](https://{} "{}")
]],
        {
          i(1, "text"),
          i(2, "address"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "[t*",
      fmt(
        [[
[{}]({} "{}")
]],
        {
          i(1, "link"),
          i(2, "`@*`"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "[tc",
      fmt(
        [[
[{}]({} "{}")
]],
        {
          i(1, "link"),
          i(2, "`@+`"),
          i(3, "title"),
        }
      )
    ),

    -- Reference style links
    new_snippet(
      "[:",
      fmt(
        [[
[{}]: https://{}
]],
        {
          i(1, "id"),
          i(2, "url"),
        }
      )
    ),

    new_snippet(
      "[:*",
      fmt(
        [[
[{}]: {}
]],
        {
          i(1, "id"),
          i(2, "`@*`"),
        }
      )
    ),

    new_snippet(
      "[:c",
      fmt(
        [[
[{}]: {}
]],
        {
          i(1, "id"),
          i(2, "`@+`"),
        }
      )
    ),

    -- Reference style links with title
    new_snippet(
      "[:t",
      fmt(
        [[
[{}]: https://{} "{}"
]],
        {
          i(1, "id"),
          i(2, "url"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "[:t*",
      fmt(
        [[
[{}]: {} "{}"
]],
        {
          i(1, "id"),
          i(2, "`@*`"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "[:tc",
      fmt(
        [[
[{}]: {} "{}"
]],
        {
          i(1, "id"),
          i(2, "`@+`"),
          i(3, "title"),
        }
      )
    ),

    -- Images
    new_snippet(
      "![",
      fmt(
        [[
![{}]({})
]],
        {
          i(1, "alttext"),
          i(2, "/images/image.jpg"),
        }
      )
    ),

    new_snippet(
      "![*",
      fmt(
        [[
![{}]({})
]],
        {
          i(1, "alt"),
          i(2, "`@*`"),
        }
      )
    ),

    new_snippet(
      "![c",
      fmt(
        [[
![{}]({})
]],
        {
          i(1, "alt"),
          i(2, "`@+`"),
        }
      )
    ),

    -- Images with title
    new_snippet(
      "![t",
      fmt(
        [[
![{}]({} "{}")
]],
        {
          i(1, "alttext"),
          i(2, "/images/image.jpg"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "![t*",
      fmt(
        [[
![{}]({} "{}")
]],
        {
          i(1, "alt"),
          i(2, "`@*`"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "![tc",
      fmt(
        [[
![{}]({} "{}")
]],
        {
          i(1, "alt"),
          i(2, "`@+`"),
          i(3, "title"),
        }
      )
    ),

    -- Image references
    new_snippet(
      "![:",
      fmt(
        [[
![{}]: {}
]],
        {
          i(1, "id"),
          i(2, "url"),
        }
      )
    ),

    new_snippet(
      "![:*",
      fmt(
        [[
![{}]: {}
]],
        {
          i(1, "id"),
          i(2, "`@*`"),
        }
      )
    ),

    -- Image references with title
    new_snippet(
      "![:t",
      fmt(
        [[
![{}]: {} "{}"
]],
        {
          i(1, "id"),
          i(2, "url"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "![:t*",
      fmt(
        [[
![{}]: {} "{}"
]],
        {
          i(1, "id"),
          i(2, "`@*`"),
          i(3, "title"),
        }
      )
    ),

    new_snippet(
      "![:tc",
      fmt(
        [[
![{}]: {} "{}"
]],
        {
          i(1, "id"),
          i(2, "`@+`"),
          i(3, "title"),
        }
      )
    ),

    -- URL
    new_snippet(
      "<",
      fmt(
        [[
<http://{}>
]],
        {
          i(1, "url"),
        }
      )
    ),

    new_snippet(
      "<*",
      t([[
<`@*`>
]])
    ),

    new_snippet(
      "<c",
      t([[
<`@+`>
]])
    ),

    -- Text formatting
    new_snippet(
      "**",
      fmt(
        [[
**{}**
]],
        {
          i(1, "bold"),
        }
      )
    ),

    new_snippet(
      "__",
      fmt(
        [[
__{}__
]],
        {
          i(1, "bold"),
        }
      )
    ),

    new_snippet(
      "===",
      t([[
`repeat('=', strlen(getline(line('.') - 3)))`

{}
]])
    ),

    new_snippet(
      "-",
      t([[
-   {}
]])
    ),

    new_snippet(
      "---",
      t([[
`repeat('-', strlen(getline(line('.') - 3)))`

{}
]])
    ),

    -- Octopress specific - using fmta to escape the curly braces
    new_snippet(
      "blockquote",
      fmta(
        [[
{% blockquote %}
<>
{% endblockquote %}
]],
        {
          i(0, "quote"),
        }
      )
    ),

    new_snippet(
      "blockquote-author",
      fmta(
        [[
{% blockquote <>, <> %}
<>
{% endblockquote %}
]],
        {
          i(1, "author"),
          i(2, "title"),
          i(0, "quote"),
        }
      )
    ),

    new_snippet(
      "blockquote-link",
      fmta(
        [[
{% blockquote <> <> <> %}
<>
{% endblockquote %}
]],
        {
          i(1, "author"),
          i(2, "URL"),
          i(3, "link_text"),
          i(0, "quote"),
        }
      )
    ),

    -- Code blocks
    new_snippet(
      "```",
      fmt(
        [[
```{}
{}
```
]],
        {
          i(1, ""),
          i(0, "VISUAL"),
        }
      )
    ),

    new_snippet(
      "```l",
      fmt(
        [[
```{}
{}
```
]],
        {
          i(1, "language"),
          i(2, "code"),
        }
      )
    ),

    -- Octopress codeblocks
    new_snippet(
      "codeblock-short",
      fmta(
        [[
{% codeblock %}
<>
{% endcodeblock %}
]],
        {
          i(0, "code_snippet"),
        }
      )
    ),

    new_snippet(
      "codeblock-full",
      fmta(
        [[
{% codeblock <> lang:<> <> <> %}
<>
{% endcodeblock %}
]],
        {
          i(1, "title"),
          i(2, "language"),
          i(3, "URL"),
          i(4, "link_text"),
          i(0, "code_snippet"),
        }
      )
    ),

    -- Gist snippets
    new_snippet(
      "gist-full",
      fmta(
        [[
{% gist <> <> %}
]],
        {
          i(1, "gist_id"),
          i(0, "filename"),
        }
      )
    ),

    new_snippet(
      "gist-short",
      fmta(
        [[
{% gist <> %}
]],
        {
          i(0, "gist_id"),
        }
      )
    ),

    new_snippet(
      "img",
      fmt(
        [[
![{}](~/images/{})
]],
        {
          i(0, "reference"),
          i(1, "image.jpg"),
        }
      )
    ),

    new_snippet(
      "youtube",
      fmta(
        [[
{% youtube <> %}
]],
        {
          i(0, "video_id"),
        }
      )
    ),

    -- Table
    new_snippet(
      "tb",
      fmt(
        [[
|  {}      |    {}       |  {}    |
| ------------- |-------------  | ------- |
|    {}    |    Y          | N       |
|    {}    |    Y          | N       |
]],
        {
          i(1, "factors"),
          i(2, "a"),
          i(3, "b"),
          i(4, "f1"),
          i(5, "f2"),
        }
      )
    ),

    -- Pullquote with fmta
    new_snippet(
      "pullquote",
      fmta(
        [[
{% pullquote %}
<> {" <> "} <>
{% endpullquote %}
]],
        {
          i(1, "text"),
          i(2, "quote"),
          i(0, "text"),
        }
      )
    ),
  },
}

return snippet
