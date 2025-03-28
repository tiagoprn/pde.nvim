local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "colors",
      t(
        'if [ -x "$(command -v tput)" ]; then\n\tbold="$(tput bold)"\n\tblack="$(tput setaf 0)"\n\tred="$(tput setaf 1)"\n\tgreen="$(tput setaf 2)"\n\tyellow="$(tput setaf 3)"\n\tblue="$(tput setaf 4)"\n\tmagenta="$(tput setaf 5)"\n\tcyan="$(tput setaf 6)"\n\twhite="$(tput setaf 7)"\n\treset="$(tput sgr0)"\nfi\n\nON="${reset}${bold}${blue}"\nOFF="${reset}${bold}${red}"\nRESET="${reset}"\n\necho "${ON} true ${RESET}"\necho "${OFF} false ${RESET}"'
      )
    ),
  },
}

return snippet
