#!/usr/bin/env bash

set -eou pipefail

# Set your virtualenv path here
VENV_PATH="$HOME/.pyenv/versions/neovim"
VIRTUALENV_NAME=$(basename "$VENV_PATH")

# Validate that the path exists and contains a virtualenv
if [ ! -d "$VENV_PATH" ]; then
    echo "Error: Directory $VENV_PATH does not exist"
    exit 1
fi

if [ ! -f "$VENV_PATH/bin/activate" ]; then
    echo "Error: $VENV_PATH does not appear to be a valid virtualenv (missing bin/activate)"
    exit 1
fi

TIMESTAMP="$(date "+%Y%m%d-%H%M-%S")"

LOGS_ROOT="$HOME/.pyenv-logs/$VIRTUALENV_NAME/auto-updates/$TIMESTAMP"
mkdir -p "$LOGS_ROOT"

# Source the virtualenv from the configured path
source "$VENV_PATH/bin/activate"

echo "-----"

echo "Updating activated virtualenv $VIRTUALENV_NAME on python version '$(python --version)'..."

uv pip --version pip-version.txt >$LOGS_ROOT/pre-update-uv

uv pip freeze >$LOGS_ROOT/pre-update-packages-versions.txt

echo "Upgrading uv pip..."
uv pip install --upgrade uv pip

echo "Generating list of outdated packages..."
uv pip list --outdated >$LOGS_ROOT/outdated_packages.txt

if [ -s "$LOGS_ROOT/outdated_packages.txt" ]; then
    echo "Outdated packages found!"
    echo "Upgrading outdated packages..."
    uv pip list --outdated | awk 'NR>2 { print $1 }' | xargs -n1 uv pip install --upgrade

    uv pip --version pip-version.txt >$LOGS_ROOT/pos-update-uv

    uv pip freeze >$LOGS_ROOT/pos-update-packages-versions.txt
else
    echo "No outdated packages found."
fi

echo "Finished updating. The update logs are at: '$LOGS_ROOT'."
