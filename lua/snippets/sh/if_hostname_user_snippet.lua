local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "if_hostname_user",
      t(
        'HOSTNAME_USER="$(hostname).$(whoami)"\nif [ "$HOSTNAME_USER" == \'cosmos.tiago\' ]; then\n        echo "do something here for tiago@cosmos"\nelif [ "$HOSTNAME_USER" == \'cosmos.tds\' ]; then\n        echo "do something here for tds@cosmos"\nfi'
      )
    ),
  },
}

return snippet
