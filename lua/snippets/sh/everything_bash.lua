
local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  sh = {
    new_snippet("#!", t([=[
	#!/usr/bin/env bash
]=])),

        new_snippet("env", t([=[
	#!/usr/bin/env bash
]=])),

        new_snippet("var_value_equals", fmt([=[
	${1:VARIABLE_NAME}=${2:value}
]=], { i(1, "VARIABLE_NAME"), i(2, "value") })),

        new_snippet("argument_from_script_with_default_value", t([=[
	# set to the value of the 1st argument passed to the script. If not passed, set "default_value".
	VAR_NAME=\${1-"default_value"}
]=])),

        new_snippet("args_get_all", t([=[
	"\$@"
]=])),

        new_snippet("if_var_value_empty", t([=[
	${1}MY_VAR="VALUE"
	if [ -z "${MY_VAR+set}" ]; then
	      echo "$MY_VAR is NULL"
	else
	      echo "$MY_VAR is NOT NULL"
	fi
]=])),

        new_snippet("if_var_value_not_empty", t([=[
	${1}MY_VAR="VALUE"
	if [ -n "${MY_VAR+set}" ]; then
	      echo "$MY_VAR has value! o/"
	else
	      echo "$MY_VAR does not have value. :("
	fi
]=])),

        new_snippet("exit_code_last_command", t([=[
	EXIT_CODE=\$?
	echo -e "EXIT_CODE=\$EXIT_CODE"
]=])),

        new_snippet("echo_date", fmt([=[
	    echo "[$(date +%r)]----> ${1:MESSAGE}"
]=], { i(1, "MESSAGE") })),

        new_snippet("multiline_comment", fmt([=[
	: '
	${1:TEXT}
	'
]=], { i(1, "TEXT") })),

        new_snippet("if_file_exists", fmt([=[
	if [ -f "${1:FILE}" ]; then
		echo "File exists \o/"
	else
		echo "File DOES NOT exist :("
	fi
]=], { i(1, "FILE") })),

        new_snippet("if_directory_exists", fmt([=[
	if [ -d "${1:DIRECTORY}" ]; then
		echo "Directory exists \o/"
	else
		echo "Directory DOES NOT exist :("
	fi
]=], { i(1, "DIRECTORY") })),

        new_snippet("if_equals", t([=[
	if [ "\$IS_PAUSED" == 'true' ]; then
	    echo 'IS TRUE \o/'
	else
	    echo 'IS FALSE :('
	fi
]=])),

        new_snippet("if_hostname_user", t([=[
	HOSTNAME_USER="$(hostname).$(whoami)"
	if [ "$HOSTNAME_USER" == 'cosmos.tiago' ]; then
            echo "do something here for tiago@cosmos"
	elif [ "$HOSTNAME_USER" == 'cosmos.tds' ]; then
            echo "do something here for tds@cosmos"
	fi
]=])),

        new_snippet("embed_python_on_bash", t([=[
	#!/bin/bash
	a=10
	b=20
	code="
	import json;
	print(json.dumps({'a': $a, 'b': $b}, indent=2))
	"
	json=$(python3 -c "$code")
	# Use json content
	echo -e "$json"
]=])),

        new_snippet("colors", t([=[
	if [ -x "\$(command -v tput)" ]; then
		bold="\$(tput bold)"
		black="\$(tput setaf 0)"
		red="\$(tput setaf 1)"
		green="\$(tput setaf 2)"
		yellow="\$(tput setaf 3)"
		blue="\$(tput setaf 4)"
		magenta="\$(tput setaf 5)"
		cyan="\$(tput setaf 6)"
		white="\$(tput setaf 7)"
		reset="\$(tput sgr0)"
	fi

	ON="\$\{reset}\$\{bold}\$\{blue}"
	OFF="\$\{reset}\$\{bold}\$\{red}"
	RESET="\$\{reset}"

	echo "\$\{ON} true \$\{RESET}"
	echo "\$\{OFF} false \$\{RESET}"
]=])),

        new_snippet("case", fmt([=[
	case ${1:word} in
		${2:pattern} )
			${0};;
	esac
]=], { i(1, "word"), i(2, "pattern") })),

        new_snippet("elif", fmt([=[
	elif ${2:[[ ${1:condition} ]]}; then
		${VISUAL}${0:#statements}
]=], { i(0, "#statements"), i(2, "[[ ${1:condition") })),

        new_snippet("script_args", t([=[
	self_name=$(basename "${0}")
	usage() {
	    echo "---"
	    echo -e "Move windows [f]rom desktop x [t]o desktop y.\n"
	    echo -e "USAGE: \n\t$self_name -f [desktop-number] -t [desktop-number]"
	}
	while getopts ":f:t:" arg; do
	    case $arg in
		f) FROM=$OPTARG ;;
		t) TO=$OPTARG ;;
		?)
		    echo "Invalid option: -${OPTARG}"
		    usage
		    exit 2
		    ;;
	    esac
	done
	if [[ (-z ${FROM+set}) || (-z ${TO+set}) ]]; then
	    usage
	    exit 1
	fi
	echo -e "FROM=$FROM"
	echo -e "TO=$TO"
]=])),

        new_snippet("script_name_and_path", t([=[
	script_name=\$(basename "\${0}")
	script_path=\$(dirname "\$(readlink -f "\${0}")")
	script_path_with_name="\$script_path/\$script_name"
	echo "script path: \$script_path"
	echo "script name: \$script_name"
	echo "script path with name: \$script_path_with_name"
]=])),

        new_snippet("script_name", t([=[
	script_name=\$(basename "\${0}")
	echo "script_name: \$script_name"
]=])),

        new_snippet("function_with_args", t([=[
	my_function()
	{
		local first_param=\${1}
		local second_param=\${2}
		echo "first param: \$first_param, second param: \$second_param"
	}

	my_function "FIRST" "SECOND"
]=])),

        new_snippet("for", fmt([=[
	for (( i = 0; i < ${1:10}; i++ )); do
		${VISUAL}${0:#statements}
	done
]=], { i(0, "#statements"), i(1, "10") })),

        new_snippet("press_any_key_to_continue", t([=[
	read -n 1 -s -r -p "Press any key to continue..."
]=])),

        new_snippet("single_args_script", t([=[
	self_name=$(basename "${0}")

	usage() {
	    echo "---"
	    echo "You must run this script passing a machine IP as argument!"
	    echo -e "USAGE: \n\t$self_name [machine-ip]"
	    echo "---"
	}

	# set to the value of the 1st argument passed to the script. If not passed, set "default_value".
	MACHINE_IP=${1-""}
	if [ "$MACHINE_IP" == "" ]; then
	    usage
	    exit 1
	fi

	read -p "Confirm $MACHINE_IP? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
]=])),

        new_snippet("input", t([=[
	read -p "Enter user: " user
	echo "USER: $user"
	read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
]=])),

        new_snippet("forin", t([=[
	WORDS="banana maçã tomate"
	for WORD in \$WORDS; do
	    echo -e "\$WORD"
	done
]=])),

        new_snippet("total_words_on_string_var", t([=[
	total_words=$(echo "$WORDS" | wc -w)
]=])),

        new_snippet("counter_inside_loop", t([=[
	# initializes the counter (put BEFORE the loop)
	counter=0
	# increments on each loop (put INSIDE the loop)
	counter=$((counter + 1))
]=])),

        new_snippet("iterate_files_on_directory", t([=[
	FILES_PATH="/path/*.txt"
	for FILE in \$FILES_PATH; do
		echo "----------------------"
		echo "Full file path: \$FILE"
		filename=\$(basename -- "\$FILE")
		echo "File name: \$filename";
	done
]=])),

        new_snippet("here", fmt([=[
	<<-${2:'${1:TOKEN}'}
		${0}
	${1/['"`](.+)['"`]/${1}/}
]=], { i(2, "'${1:TOKEN") })),

        new_snippet("if", fmt([=[
	if ${2:[[ ${1:condition} ]]}; then
		${VISUAL}${0:#statements}
	fi
]=], { i(0, "#statements"), i(2, "[[ ${1:condition") })),

        new_snippet("until", fmt([=[
	until ${2:[[ ${1:condition} ]]}; do
		${0:#statements}
	done
]=], { i(0, "#statements"), i(2, "[[ ${1:condition") })),

        new_snippet("while", fmt([=[
	while ${2:[[ ${1:condition} ]]}; do
		${0:#statements}
	done
]=], { i(0, "#statements"), i(2, "[[ ${1:condition") })),

        new_snippet("fun", fmt([=[
	function ${1:name}(${2}) {
		${3}
	}
]=], { i(1, "name") })),

        new_snippet("datesh", t([=[
	TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"
]=])),

        new_snippet("hashmap_loop", t([=[
	declare -A ${1}MAPPINGS=(
	    ['k1']="value1"
	    ['k2']="value2"
	    ['k3']="value3"
	)
	for key in "${!MAPPINGS[@]}"; do
	    value=${MAPPINGS[$key]}
	    echo "$key value is: $value"
	done

]=])),

        new_snippet("redirect_stdout_stderr_to_file", t([=[
	: '
	Bash executes the redirects from left to right as follows:
	    >>file.txt: Open file.txt in append mode and redirect stdout there.
	    2>&1: Redirect stderr to "where stdout is currently going". In this case, that is a file opened in append mode. In other words, the &1 reuses the file descriptor which stdout currently uses.
	'
	cmd >>file.txt 2>&1
]=])),

        new_snippet("aliases_enable", t([=[
	shopt -s expand_aliases
	source $HOME/.bashrc

	${1}
]=])),

        new_snippet("return_code", t([=[
	status=$?
	[ $status -eq 0 ] && echo "command successful" || echo "command unsuccessful"
]=])),

        new_snippet("colors", t([=[
	# Define color variables
	RED='\033[0;31m'
	NC='\033[0m' # No Color

	# example: Print part of a string in red
	echo -e "This is \${RED}a test\${NC}, and the remaining is back to normal font color."
]=])),

        new_snippet("bash!", t([=[
	#!/usr/bin/env bash

	#  Minimal safe Bash script template - see the article with full description: https://betterdev.blog/minimal-safe-bash-script-template/

	set -Eeuo pipefail
	trap cleanup SIGINT SIGTERM ERR EXIT

	script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

	usage() {
	  cat <<EOF
	Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

	Script description here.

	Available options:

	-h, --help      Print this help and exit
	-v, --verbose   Print script debug info
	-f, --flag      Some flag description
	-p, --param     Some param description
	EOF
	  exit
	}

	cleanup() {
	  trap - SIGINT SIGTERM ERR EXIT
	  # script cleanup here
	}

	setup_colors() {
	  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
	    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
	  else
	    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
	  fi
	}

	msg() {
	  echo >&2 -e "${1-}"
	}

	die() {
	  local msg=${1}
	  local code=${2-1} # default exit status 1
	  msg "$msg"
	  exit "$code"
	}

	parse_params() {
	  # default values of variables set from params
	  flag=0
	  param=''

	  while :; do
	    case "${1-}" in
	    -h | --help) usage ;;
	    -v | --verbose) set -x ;;
	    --no-color) NO_COLOR=1 ;;
	    -f | --flag) flag=1 ;; # example flag
	    -p | --param) # example named parameter
	      param="${2-}"
	      shift
	      ;;
	    -?*) die "Unknown option: ${1}" ;;
	    *) break ;;
	    esac
	    shift
	  done

	  args=("$@")

	  # check required params and arguments
	  [[ -z "${param-}" ]] && die "Missing required parameter: param"
	  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

	  return 0
	}

	parse_params "$@"
	setup_colors

	# script logic here

	msg "${RED}Read parameters:${NOFORMAT}"
	msg "- flag: ${flag}"
	msg "- param: ${param}"
	msg "- arguments: ${args[*]-}"
]=]))
  },
}

return snippet
