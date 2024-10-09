#!/usr/bin/env bash

TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"

ROOT_SOURCES_DIR="/opt/src"

echo "Moving current instalattion directory..."
sudo mv $ROOT_SOURCES_DIR/neovim $ROOT_SOURCES_DIR/neovim."$TIMESTAMP"

echo "Cloning neovim repository again..."
sudo bash -c "cd $ROOT_SOURCES_DIR && git clone https://github.com/neovim/neovim.git"

echo -e "FINISHED! \n Now you can manually run './sync-neovim.sh' again. "
