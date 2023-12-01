#!/usr/bin/env bash

# Path to your pyenv installation
export PYENV_ROOT="$HOME/.pyenv"

# Set the desired Python version and virtualenv name
PYTHON_VERSION="3.10.4"
VIRTUALENV_NAME="neovim"

TIMESTAMP="$(date "+%Y%m%d-%H%M-%S")"

LOGS_ROOT="$HOME/.pyenv-logs/$PYTHON_VERSION-$VIRTUALENV_NAME/auto-updates/$TIMESTAMP"
mkdir -p "$LOGS_ROOT"

source "$PYENV_ROOT/versions/$PYTHON_VERSION/envs/$VIRTUALENV_NAME/bin/activate"

echo "-----"

echo "Updating activated virtualenv $VIRTUALENV_NAME on python version '$(python --version)'..."

pip --version >$LOGS_ROOT/pre-update-pip-version.txt

pip freeze >$LOGS_ROOT/pre-update-packages-versions.txt

echo "Upgrading pip..."
pip install --upgrade pip

echo "Generating list of outdated packages..."
pip list --outdated >$LOGS_ROOT/outdated_packages.txt

if [ -s "$LOGS_ROOT/outdated_packages.txt" ]; then
    echo "Outdated packages found!"
    echo "Upgrading outdated packages..."
    pip list --outdated | awk 'NR>2 { print $1 }' | xargs -n1 pip install --upgrade # "NR>2" ignores the first 2 lines, which are not package names.

    pip --version >$LOGS_ROOT/pos-update-pip-version.txt

    pip freeze >$LOGS_ROOT/pos-update-packages-versions.txt
else
    echo "No outdated packages found."
fi

echo "Finished updating. The update logs are at: '$LOGS_ROOT'."
