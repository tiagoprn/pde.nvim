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

echo "Generating list of outdated packages..."
pip list --outdated >$LOGS_ROOT/outdated_packages.txt

# I won't update jedi and jedi-language-server after they are installed.
# When upgrading jedi-language-server from 0.44.0 to 0.45.0 it broke go-to-definitions,
# so I had to downgrade it manually.
# So, the code below effectively freezes this package on the current version and do not upgrade it anymore.
if grep -n '^jedi' "$LOGS_ROOT/outdated_packages.txt"; then
    echo "Above lines starting with 'jedi' were found and will be removed."
    sed -i '/^jedi/d' "$LOGS_ROOT/outdated_packages.txt"
else
    echo "No lines starting with 'jedi' found."
fi

# Now check if the file has only 2 lines (header + separator), delete it.
if [ "$(wc -l <"$LOGS_ROOT/outdated_packages.txt")" -eq 2 ]; then
    echo "File has only 2 lines left, deleting it."
    rm "$LOGS_ROOT/outdated_packages.txt"
fi

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
