local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "script_args",
      t(
        'self_name=$(basename "${0}")\nusage() {\n    echo "---"\n    echo -e "Move windows [f]rom desktop x [t]o desktop y.\\n"\n    echo -e "USAGE: \\n\\t$self_name -f [desktop-number] -t [desktop-number]"\n}\nwhile getopts ":f:t:" arg; do\n    case $arg in\n\tf) FROM=$OPTARG ;;\n\tt) TO=$OPTARG ;;\n\t?)\n\t    echo "Invalid option: -${OPTARG}"\n\t    usage\n\t    exit 2\n\t    ;;\n    esac\ndone\nif [[ (-z ${FROM+set}) || (-z ${TO+set}) ]]; then\n    usage\n    exit 1\nfi\necho -e "FROM=$FROM"\necho -e "TO=$TO"'
      )
    ),
  },
}

return snippet
