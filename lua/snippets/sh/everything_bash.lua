local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.s -- for clarity in new format

local snippet = {
  sh = {
    -- Simple snippets with text nodes
    new_snippet("#!", t("#!/usr/bin/env bash")),

    new_snippet("env", t("#!/usr/bin/env bash")),

    -- Use fmt with simpler braces
    s(
      "var_value_equals",
      fmt("{}={}", {
        i(1, "VARIABLE_NAME"),
        i(2, "value"),
      })
    ),

    new_snippet(
      "argument_from_script_with_default_value",
      t(
        '# set to the value of the 1st argument passed to the script. If not passed, set "default_value".\nVAR_NAME=${1-"default_value"}'
      )
    ),

    new_snippet("args_get_all", t('"$@"')),

    new_snippet(
      "if_var_value_empty",
      t(
        'MY_VAR="VALUE"\nif [ -z "${MY_VAR+set}" ]; then\n      echo "$MY_VAR is NULL"\nelse\n      echo "$MY_VAR is NOT NULL"\nfi'
      )
    ),

    new_snippet(
      "if_var_value_not_empty",
      t(
        'MY_VAR="VALUE"\nif [ -n "${MY_VAR+set}" ]; then\n      echo "$MY_VAR has value! o/"\nelse\n      echo "$MY_VAR does not have value. :("\nfi'
      )
    ),

    new_snippet("exit_code_last_command", t('EXIT_CODE=$?\necho -e "EXIT_CODE=$EXIT_CODE"')),

    -- Use simple fmt with proper escaping for echo
    s(
      "echo_date",
      fmt('echo "[$(date +%r)]----> {}"', {
        i(1, "MESSAGE"),
      })
    ),

    s(
      "multiline_comment",
      fmt(": '\n{}\n'", {
        i(1, "TEXT"),
      })
    ),

    s(
      "if_file_exists",
      fmt('if [ -f "{}" ]; then\n\techo "File exists \\o/"\nelse\n\techo "File DOES NOT exist :("\nfi', {
        i(1, "FILE"),
      })
    ),

    s(
      "if_directory_exists",
      fmt('if [ -d "{}" ]; then\n\techo "Directory exists \\o/"\nelse\n\techo "Directory DOES NOT exist :("\nfi', {
        i(1, "DIRECTORY"),
      })
    ),

    new_snippet(
      "if_equals",
      t("if [ \"$IS_PAUSED\" == 'true' ]; then\n    echo 'IS TRUE \\o/'\nelse\n    echo 'IS FALSE :('\nfi")
    ),

    new_snippet(
      "if_hostname_user",
      t(
        'HOSTNAME_USER="$(hostname).$(whoami)"\nif [ "$HOSTNAME_USER" == \'cosmos.tiago\' ]; then\n        echo "do something here for tiago@cosmos"\nelif [ "$HOSTNAME_USER" == \'cosmos.tds\' ]; then\n        echo "do something here for tds@cosmos"\nfi'
      )
    ),

    new_snippet(
      "embed_python_on_bash",
      t(
        '#!/bin/bash\na=10\nb=20\ncode="\nimport json;\nprint(json.dumps({\'a\': $a, \'b\': $b}, indent=2))\n"\njson=$(python3 -c "$code")\n# Use json content\necho -e "$json"'
      )
    ),

    new_snippet(
      "colors",
      t(
        'if [ -x "$(command -v tput)" ]; then\n\tbold="$(tput bold)"\n\tblack="$(tput setaf 0)"\n\tred="$(tput setaf 1)"\n\tgreen="$(tput setaf 2)"\n\tyellow="$(tput setaf 3)"\n\tblue="$(tput setaf 4)"\n\tmagenta="$(tput setaf 5)"\n\tcyan="$(tput setaf 6)"\n\twhite="$(tput setaf 7)"\n\treset="$(tput sgr0)"\nfi\n\nON="${reset}${bold}${blue}"\nOFF="${reset}${bold}${red}"\nRESET="${reset}"\n\necho "${ON} true ${RESET}"\necho "${OFF} false ${RESET}"'
      )
    ),

    s(
      "case",
      fmt("case {} in\n\t{} )\n\t\t{};;\nesac", {
        i(1, "word"),
        i(2, "pattern"),
        i(0, ""),
      })
    ),

    s(
      "elif",
      fmt("elif {}; then\n\t{}", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    new_snippet(
      "script_args",
      t(
        'self_name=$(basename "${0}")\nusage() {\n    echo "---"\n    echo -e "Move windows [f]rom desktop x [t]o desktop y.\\n"\n    echo -e "USAGE: \\n\\t$self_name -f [desktop-number] -t [desktop-number]"\n}\nwhile getopts ":f:t:" arg; do\n    case $arg in\n\tf) FROM=$OPTARG ;;\n\tt) TO=$OPTARG ;;\n\t?)\n\t    echo "Invalid option: -${OPTARG}"\n\t    usage\n\t    exit 2\n\t    ;;\n    esac\ndone\nif [[ (-z ${FROM+set}) || (-z ${TO+set}) ]]; then\n    usage\n    exit 1\nfi\necho -e "FROM=$FROM"\necho -e "TO=$TO"'
      )
    ),

    new_snippet(
      "script_name_and_path",
      t(
        'script_name=$(basename "${0}")\nscript_path=$(dirname "$(readlink -f "${0}")")\nscript_path_with_name="$script_path/$script_name"\necho "script path: $script_path"\necho "script name: $script_name"\necho "script path with name: $script_path_with_name"'
      )
    ),

    new_snippet("script_name", t('script_name=$(basename "${0}")\necho "script_name: $script_name"')),

    new_snippet(
      "function_with_args",
      t(
        'my_function()\n{\n\tlocal first_param=${1}\n\tlocal second_param=${2}\n\techo "first param: $first_param, second param: $second_param"\n}\n\nmy_function "FIRST" "SECOND"'
      )
    ),

    s(
      "for",
      fmt("for (( i = 0; i < {}; i++ )); do\n\t{}\ndone", {
        i(1, "10"),
        i(0, "#statements"),
      })
    ),

    new_snippet("press_any_key_to_continue", t('read -n 1 -s -r -p "Press any key to continue..."')),

    new_snippet(
      "single_args_script",
      t(
        'self_name=$(basename "${0}")\n\nusage() {\n    echo "---"\n    echo "You must run this script passing a machine IP as argument!"\n    echo -e "USAGE: \\n\\t$self_name [machine-ip]"\n    echo "---"\n}\n\n# set to the value of the 1st argument passed to the script. If not passed, set "default_value".\nMACHINE_IP=${1-""}\nif [ "$MACHINE_IP" == "" ]; then\n    usage\n    exit 1\nfi\n\nread -p "Confirm $MACHINE_IP? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1'
      )
    ),

    new_snippet(
      "input",
      t(
        'read -p "Enter user: " user\necho "USER: $user"\nread -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1'
      )
    ),

    new_snippet("forin", t('WORDS="banana maçã tomate"\nfor WORD in $WORDS; do\n    echo -e "$WORD"\ndone')),

    new_snippet("total_words_on_string_var", t('total_words=$(echo "$WORDS" | wc -w)')),

    new_snippet(
      "counter_inside_loop",
      t(
        "# initializes the counter (put BEFORE the loop)\ncounter=0\n# increments on each loop (put INSIDE the loop)\ncounter=$((counter + 1))"
      )
    ),

    new_snippet(
      "iterate_files_on_directory",
      t(
        'FILES_PATH="/path/*.txt"\nfor FILE in $FILES_PATH; do\n\techo "----------------------"\n\techo "Full file path: $FILE"\n\tfilename=$(basename -- "$FILE")\n\techo "File name: $filename";\ndone'
      )
    ),

    s(
      "here",
      fmt("<<-{}\n\t{}\n{}", {
        i(1, "'TOKEN'"),
        i(2, ""),
        i(3, "TOKEN"),
      })
    ),

    s(
      "if",
      fmt("if {}; then\n\t{}\nfi", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    s(
      "until",
      fmt("until {}; do\n\t{}\ndone", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    s(
      "while",
      fmt("while {}; do\n\t{}\ndone", {
        i(1, "[[ condition ]]"),
        i(0, "#statements"),
      })
    ),

    s(
      "fun",
      fmt("function {}({}) {{\n\t{}\n}}", {
        i(1, "name"),
        i(2, ""),
        i(0, ""),
      })
    ),

    new_snippet("datesh", t('TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"')),

    new_snippet(
      "hashmap_loop",
      t(
        'declare -A MAPPINGS=(\n    [\'k1\']="value1"\n    [\'k2\']="value2"\n    [\'k3\']="value3"\n)\nfor key in "${!MAPPINGS[@]}"; do\n    value=${MAPPINGS[$key]}\n    echo "$key value is: $value"\ndone\n'
      )
    ),

    new_snippet(
      "redirect_stdout_stderr_to_file",
      t(
        ": '\nBash executes the redirects from left to right as follows:\n    >>file.txt: Open file.txt in append mode and redirect stdout there.\n    2>&1: Redirect stderr to \"where stdout is currently going\". In this case, that is a file opened in append mode. In other words, the &1 reuses the file descriptor which stdout currently uses.\n'\ncmd >>file.txt 2>&1"
      )
    ),

    s(
      "aliases_enable",
      fmt("shopt -s expand_aliases\nsource $HOME/.bashrc\n\n{}", {
        i(0, ""),
      })
    ),

    new_snippet(
      "return_code",
      t('status=$?\n[ $status -eq 0 ] && echo "command successful" || echo "command unsuccessful"')
    ),

    new_snippet(
      "colors_simple",
      t(
        "# Define color variables\nRED='\\033[0;31m'\nNC='\\033[0m' # No Color\n\n# example: Print part of a string in red\necho -e \"This is ${RED}a test${NC}, and the remaining is back to normal font color.\""
      )
    ),

    new_snippet(
      "bash!",
      t(
        '#!/usr/bin/env bash\n\n#  Minimal safe Bash script template - see the article with full description: https://betterdev.blog/minimal-safe-bash-script-template/\n\nset -Eeuo pipefail\ntrap cleanup SIGINT SIGTERM ERR EXIT\n\nscript_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)\n\nusage() {\n  cat <<EOF\nUsage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]\n\nScript description here.\n\nAvailable options:\n\n-h, --help      Print this help and exit\n-v, --verbose   Print script debug info\n-f, --flag      Some flag description\n-p, --param     Some param description\nEOF\n  exit\n}\n\ncleanup() {\n  trap - SIGINT SIGTERM ERR EXIT\n  # script cleanup here\n}\n\nsetup_colors() {\n  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then\n    NOFORMAT=\'\\033[0m\' RED=\'\\033[0;31m\' GREEN=\'\\033[0;32m\' ORANGE=\'\\033[0;33m\' BLUE=\'\\033[0;34m\' PURPLE=\'\\033[0;35m\' CYAN=\'\\033[0;36m\' YELLOW=\'\\033[1;33m\'\n  else\n    NOFORMAT=\'\' RED=\'\' GREEN=\'\' ORANGE=\'\' BLUE=\'\' PURPLE=\'\' CYAN=\'\' YELLOW=\'\'\n  fi\n}\n\nmsg() {\n  echo >&2 -e "${1-}"\n}\n\ndie() {\n  local msg=${1}\n  local code=${2-1} # default exit status 1\n  msg "$msg"\n  exit "$code"\n}\n\nparse_params() {\n  # default values of variables set from params\n  flag=0\n  param=\'\'\n\n  while :; do\n    case "${1-}" in\n    -h | --help) usage ;;\n    -v | --verbose) set -x ;;\n    --no-color) NO_COLOR=1 ;;\n    -f | --flag) flag=1 ;; # example flag\n    -p | --param) # example named parameter\n      param="${2-}"\n      shift\n      ;;\n    -?*) die "Unknown option: ${1}" ;;\n    *) break ;;\n    esac\n    shift\n  done\n\n  args=("$@")\n\n  # check required params and arguments\n  [[ -z "${param-}" ]] && die "Missing required parameter: param"\n  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"\n\n  return 0\n}\n\nparse_params "$@"\nsetup_colors\n\n# script logic here\n\nmsg "${RED}Read parameters:${NOFORMAT}"\nmsg "- flag: ${flag}"\nmsg "- param: ${param}"\nmsg "- arguments: ${args[*]-}"'
      )
    ),
  },
}

return snippet
