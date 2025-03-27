local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

-- TODO: add this snippet: Minimal safe Bash script template - see the article with full description: https://betterdev.blog/minimal-safe-bash-script-template/

local snippet = {
  sh = {
    simple_text_snippet("env", t("#!/usr/bin/env bash")),

    interactive_snippet(
      "var_value_equals",
      fmt("{}={}", {
        i(1, "VARIABLE_NAME"),
        i(2, "value"),
      })
    ),

    simple_text_snippet(
      "argument_from_script_with_default_value",
      t(
        '# set to the value of the 1st argument passed to the script. If not passed, set "default_value".\nVAR_NAME=${1-"default_value"}'
      )
    ),

    simple_text_snippet("args_get_all", t('"$@"')),

    simple_text_snippet(
      "if_var_value_empty",
      t(
        'MY_VAR="VALUE"\nif [ -z "${MY_VAR+set}" ]; then\n      echo "$MY_VAR is NULL"\nelse\n      echo "$MY_VAR is NOT NULL"\nfi'
      )
    ),

    simple_text_snippet(
      "if_var_value_not_empty",
      t(
        'MY_VAR="VALUE"\nif [ -n "${MY_VAR+set}" ]; then\n      echo "$MY_VAR has value! o/"\nelse\n      echo "$MY_VAR does not have value. :("\nfi'
      )
    ),

    simple_text_snippet("exit_code_last_command", t('EXIT_CODE=$?\necho -e "EXIT_CODE=$EXIT_CODE"')),

    -- Use simple fmt with proper escaping for echo
    interactive_snippet(
      "echo_date",
      fmt('echo "[$(date +%r)]----> {}"', {
        i(1, "MESSAGE"),
      })
    ),

    interactive_snippet(
      "multiline_comment",
      fmt(": '\n{}\n'", {
        i(1, "TEXT"),
      })
    ),

    interactive_snippet(
      "if_file_exists",
      fmt('if [ -f "{}" ]; then\n\techo "File exists \\o/"\nelse\n\techo "File DOES NOT exist :("\nfi', {
        i(1, "FILE"),
      })
    ),

    interactive_snippet(
      "if_directory_exists",
      fmt('if [ -d "{}" ]; then\n\techo "Directory exists \\o/"\nelse\n\techo "Directory DOES NOT exist :("\nfi', {
        i(1, "DIRECTORY"),
      })
    ),

    simple_text_snippet(
      "if_equals",
      t("if [ \"$IS_PAUSED\" == 'true' ]; then\n    echo 'IS TRUE \\o/'\nelse\n    echo 'IS FALSE :('\nfi")
    ),

    simple_text_snippet(
      "if_hostname_user",
      t(
        'HOSTNAME_USER="$(hostname).$(whoami)"\nif [ "$HOSTNAME_USER" == \'cosmos.tiago\' ]; then\n        echo "do something here for tiago@cosmos"\nelif [ "$HOSTNAME_USER" == \'cosmos.tds\' ]; then\n        echo "do something here for tds@cosmos"\nfi'
      )
    ),

    simple_text_snippet(
      "embed_python_on_bash",
      t(
        '#!/bin/bash\na=10\nb=20\ncode="\nimport json;\nprint(json.dumps({\'a\': $a, \'b\': $b}, indent=2))\n"\njson=$(python3 -c "$code")\n# Use json content\necho -e "$json"'
      )
    ),

    simple_text_snippet(
      "colors",
      t(
        'if [ -x "$(command -v tput)" ]; then\n\tbold="$(tput bold)"\n\tblack="$(tput setaf 0)"\n\tred="$(tput setaf 1)"\n\tgreen="$(tput setaf 2)"\n\tyellow="$(tput setaf 3)"\n\tblue="$(tput setaf 4)"\n\tmagenta="$(tput setaf 5)"\n\tcyan="$(tput setaf 6)"\n\twhite="$(tput setaf 7)"\n\treset="$(tput sgr0)"\nfi\n\nON="${reset}${bold}${blue}"\nOFF="${reset}${bold}${red}"\nRESET="${reset}"\n\necho "${ON} true ${RESET}"\necho "${OFF} false ${RESET}"'
      )
    ),

    interactive_snippet(
      "case",
      fmt("case {} in\n\t{} )\n\t\t{};;\nesac", {
        i(1, "word"),
        i(2, "pattern"),
        i(0, ""),
      })
    ),

    interactive_snippet(
      "elif",
      fmt("elif {}; then\n\t{}", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    simple_text_snippet(
      "script_args",
      t(
        'self_name=$(basename "${0}")\nusage() {\n    echo "---"\n    echo -e "Move windows [f]rom desktop x [t]o desktop y.\\n"\n    echo -e "USAGE: \\n\\t$self_name -f [desktop-number] -t [desktop-number]"\n}\nwhile getopts ":f:t:" arg; do\n    case $arg in\n\tf) FROM=$OPTARG ;;\n\tt) TO=$OPTARG ;;\n\t?)\n\t    echo "Invalid option: -${OPTARG}"\n\t    usage\n\t    exit 2\n\t    ;;\n    esac\ndone\nif [[ (-z ${FROM+set}) || (-z ${TO+set}) ]]; then\n    usage\n    exit 1\nfi\necho -e "FROM=$FROM"\necho -e "TO=$TO"'
      )
    ),

    simple_text_snippet(
      "script_name_and_path",
      t(
        'script_name=$(basename "${0}")\nscript_path=$(dirname "$(readlink -f "${0}")")\nscript_path_with_name="$script_path/$script_name"\necho "script path: $script_path"\necho "script name: $script_name"\necho "script path with name: $script_path_with_name"'
      )
    ),

    simple_text_snippet("script_name", t('script_name=$(basename "${0}")\necho "script_name: $script_name"')),

    simple_text_snippet(
      "function_with_args",
      t(
        'my_function()\n{\n\tlocal first_param=${1}\n\tlocal second_param=${2}\n\techo "first param: $first_param, second param: $second_param"\n}\n\nmy_function "FIRST" "SECOND"'
      )
    ),

    interactive_snippet(
      "for",
      fmt("for (( i = 0; i < {}; i++ )); do\n\t{}\ndone", {
        i(1, "10"),
        i(0, "#statements"),
      })
    ),

    simple_text_snippet("press_any_key_to_continue", t('read -n 1 -s -r -p "Press any key to continue..."')),

    simple_text_snippet(
      "single_args_script",
      t(
        'self_name=$(basename "${0}")\n\nusage() {\n    echo "---"\n    echo "You must run this script passing a machine IP as argument!"\n    echo -e "USAGE: \\n\\t$self_name [machine-ip]"\n    echo "---"\n}\n\n# set to the value of the 1st argument passed to the script. If not passed, set "default_value".\nMACHINE_IP=${1-""}\nif [ "$MACHINE_IP" == "" ]; then\n    usage\n    exit 1\nfi\n\nread -p "Confirm $MACHINE_IP? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1'
      )
    ),

    simple_text_snippet(
      "input",
      t(
        'read -p "Enter user: " user\necho "USER: $user"\nread -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1'
      )
    ),

    simple_text_snippet("forin", t('WORDS="banana maçã tomate"\nfor WORD in $WORDS; do\n    echo -e "$WORD"\ndone')),

    simple_text_snippet("total_words_on_string_var", t('total_words=$(echo "$WORDS" | wc -w)')),

    simple_text_snippet(
      "counter_inside_loop",
      t(
        "# initializes the counter (put BEFORE the loop)\ncounter=0\n# increments on each loop (put INSIDE the loop)\ncounter=$((counter + 1))"
      )
    ),

    simple_text_snippet(
      "iterate_files_on_directory",
      t(
        'FILES_PATH="/path/*.txt"\nfor FILE in $FILES_PATH; do\n\techo "----------------------"\n\techo "Full file path: $FILE"\n\tfilename=$(basename -- "$FILE")\n\techo "File name: $filename";\ndone'
      )
    ),

    interactive_snippet(
      "here",
      fmt("<<-{}\n\t{}\n{}", {
        i(1, "'TOKEN'"),
        i(2, ""),
        i(3, "TOKEN"),
      })
    ),

    interactive_snippet(
      "if",
      fmt("if {}; then\n\t{}\nfi", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    interactive_snippet(
      "until",
      fmt("until {}; do\n\t{}\ndone", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    interactive_snippet(
      "while",
      fmt("while {}; do\n\t{}\ndone", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    interactive_snippet(
      "fun",
      fmt("function {}({}) {{\n\t{}\n}}", {
        i(1, "name"),
        i(2, ""),
        i(0, ""),
      })
    ),

    simple_text_snippet("datesh", t('TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"')),

    simple_text_snippet(
      "hashmap_loop",
      t(
        'declare -A MAPPINGS=(\n    [\'k1\']="value1"\n    [\'k2\']="value2"\n    [\'k3\']="value3"\n)\nfor key in "${!MAPPINGS[@]}"; do\n    value=${MAPPINGS[$key]}\n    echo "$key value is: $value"\ndone\n'
      )
    ),

    simple_text_snippet(
      "redirect_stdout_stderr_to_file",
      t(
        ": '\nBash executes the redirects from left to right as follows:\n    >>file.txt: Open file.txt in append mode and redirect stdout there.\n    2>&1: Redirect stderr to \"where stdout is currently going\". In this case, that is a file opened in append mode. In other words, the &1 reuses the file descriptor which stdout currently uses.\n'\ncmd >>file.txt 2>&1"
      )
    ),

    interactive_snippet(
      "aliases_enable",
      fmt("shopt -s expand_aliases\nsource $HOME/.bashrc\n\n{}", {
        i(0, ""),
      })
    ),

    simple_text_snippet(
      "return_code",
      t('status=$?\n[ $status -eq 0 ] && echo "command successful" || echo "command unsuccessful"')
    ),

    simple_text_snippet(
      "colors_simple",
      t(
        "# Define color variables\nRED='\\033[0;31m'\nNC='\\033[0m' # No Color\n\n# example: Print part of a string in red\necho -e \"This is ${RED}a test${NC}, and the remaining is back to normal font color.\""
      )
    ),
  },
}

return snippet
