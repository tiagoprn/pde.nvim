#!/bin/bash

: '
This script (re)compiles neovim from its official repository.
'

NVIM_SOURCES_PATH=/opt/src/neovim
NVIM_BINARY_PATH=/usr/local/bin/nvim

# Cleanup existing install and compile a new one
PREVIOUS_VERSION=$(sudo -- bash -c "cd $NVIM_SOURCES_PATH && git log -n 1 --pretty=format:'%cD by %an (%h)'")

BACKUPS_ROOT=$NVIM_SOURCES_PATH/tmp/OLD-VERSIONS-ARCHIVE
SUFFIX="$(date +%Y%m%d-%H%M%S-%N)"
BACKUPS_DIR=$BACKUPS_ROOT/$SUFFIX

sudo mkdir -p $BACKUPS_DIR
sudo cp -farv $NVIM_BINARY_PATH $BACKUPS_DIR
echo "The old nvim binary was copied to $BACKUPS_DIR in case you need to manually revert it to $NVIM_BINARY_PATH."

echo "Compiling nvim (this will take a while)..."
echo -e "If the build fails because of old version of libraries,\n run the script 'nvim-clean-cmake-build-cache.sh'\n to delete cmake cache and rebuild from a pristine state."
read -n 1 -s -r -p "Press any key to continue..."
COMMANDS="cd $NVIM_SOURCES_PATH && git fetch && git pull && rm -fr $NVIM_SOURCES_PATH/build && make clean && make CMAKE_BUILD_TYPE=Release && make install"
sudo -- bash -c "$COMMANDS"

NEW_VERSION=$(sudo -- bash -c "cd $NVIM_SOURCES_PATH && git log -n 1 --pretty=format:'%cD by %an (%h)'")

message="\nFinished compiling nvim.\n\nPrevious version:\n\t$PREVIOUS_VERSION\nNew version:\n\t$NEW_VERSION\n\nHave fun! \o/"
echo "-----------------"
echo -e "$message"
echo "-----------------"
