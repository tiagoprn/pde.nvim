local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "single_args_script",
      t(
        'self_name=$(basename "${0}")\n\nusage() {\n    echo "---"\n    echo "You must run this script passing a machine IP as argument!"\n    echo -e "USAGE: \\n\\t$self_name [machine-ip]"\n    echo "---"\n}\n\n# set to the value of the 1st argument passed to the script. If not passed, set "default_value".\nMACHINE_IP=${1-""}\nif [ "$MACHINE_IP" == "" ]; then\n    usage\n    exit 1\nfi\n\nread -p "Confirm $MACHINE_IP? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1'
      )
    ),
  },
}

return snippet
