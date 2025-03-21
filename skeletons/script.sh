#!/usr/bin/env bash

set -eou pipefail

shopt -s expand_aliases

LOG_DIR="$HOME/tmp"
SCRIPT_NAME=$(basename "$0")

usage() {
    echo "usage: script.sh -p value"
}

no_args="true"
while getopts ":p:" arg; do
    case $arg in
        p) VALUE=$OPTARG ;;
        *) echo "invalid parameter" && {
            usage
            exit 1
        } ;;
    esac
    no_args="false"
done

[[ $no_args == "true" ]] && {
    usage
    exit 1
}

echo -e "VALUE=$VALUE"

my-command-here >>"$LOG_DIR/$SCRIPT_NAME.log" 2>&1
