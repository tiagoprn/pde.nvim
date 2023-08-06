#!/usr/bin/env bash

TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"

echo "Moving current instalattion directory..."
sudo mv /storage/vendors/neovim /storage/vendors/neovim."$TIMESTAMP"

echo "Cloning neovim repository again..."
sudo bash -c "cd /storage/vendors && git clone https://github.com/neovim/neovim.git"

echo -e "FINISHED! \n Now you can manually run './sync-neovim.sh' again. "
