#!/usr/bin/env bash

set -eou pipefail

# Path to your pyenv installation
export PYENV_ROOT="$HOME/.pyenv"

# Set the desired Python version and virtualenv name
VIRTUALENV_NAME="neovim"

TIMESTAMP="$(date "+%Y%m%d-%H%M-%S")"

LOGS_ROOT="$HOME/.pyenv-logs/$VIRTUALENV_NAME/auto-updates/$TIMESTAMP"
mkdir -p "$LOGS_ROOT"

source "$PYENV_ROOT/versions/$VIRTUALENV_NAME/bin/activate"

echo "-----"

echo "Updating activated virtualenv $VIRTUALENV_NAME on python version '$(python --version)'..."

pip --version >$LOGS_ROOT/pre-update-pip-version.txt

pip freeze >$LOGS_ROOT/pre-update-packages-versions.txt

echo "Upgrading pip..."
pip install --upgrade pip

PACKAGES_LIST=$(cat /storage/src/devops/python/requirements.nvim-lsp | grep -Ev '^#|^[[:space:]]*$')

echo -e "$PACKAGES_LIST" >$LOGS_ROOT/packages-list.txt

echo "Updating packages: $PACKAGES_LIST..."
echo "$PACKAGES_LIST" | while IFS= read -r package; do
    if [[ -n $package ]]; then
        echo "Updating $package..."
        pip install --upgrade "$package"
    fi
done

pip freeze >$LOGS_ROOT/post-update-packages-versions.txt

echo -e "\n---\nUPDATE DIFF: "
difft "$LOGS_ROOT/pre-update-packages-versions.txt" "$LOGS_ROOT/post-update-packages-versions.txt"

echo "Finished updating. The update logs are at: '$LOGS_ROOT'."
