#!/usr/bin/env bash

set -eou pipefail

# Path to your pyenv installation
export VENV_ROOT="$HOME/.pyenv"

# Set the desired Python version and virtualenv name
VIRTUALENV_NAME="neovim"

TIMESTAMP="$(date "+%Y%m%d-%H%M-%S")"

UV_LOGS_ROOT="$HOME/.uv-logs/"
LOGS_ROOT="$UV_LOGS_ROOT/$VIRTUALENV_NAME/auto-updates/$TIMESTAMP"
mkdir -p "$LOGS_ROOT"

source "$VENV_ROOT/versions/$VIRTUALENV_NAME/bin/activate"

echo "-----"

echo "Updating activated virtualenv $VIRTUALENV_NAME on python version '$(python --version)'..."

uv pip freeze >$LOGS_ROOT/pre-update-packages-versions.txt

echo "Generating list of outdated packages..."
uv pip list --outdated >$LOGS_ROOT/outdated_packages.txt

if [ -s "$LOGS_ROOT/outdated_packages.txt" ]; then
    echo "Outdated packages found!"
    echo "Upgrading outdated packages..."
    uv pip list --outdated | awk 'NR>2 { print $1 }' | xargs -n1 uv pip install --upgrade # "NR>2" ignores the first 2 lines, which are not package names.

    uv pip freeze >$LOGS_ROOT/pos-update-packages-versions.txt
else
    echo "No outdated packages found."
fi

echo "Finished updating. The update logs are at: '$LOGS_ROOT'."
