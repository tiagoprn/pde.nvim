#!/bin/bash

TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"

echo "Moving current instalattion directory..."
sudo mv /opt/src/neovim /opt/src/neovim."$TIMESTAMP"

echo "Cloning neovim repository again..."
sudo bash -c "cd /opt/src && git clone https://github.com/neovim/neovim.git"

echo -e "FINISHED! \n Now you can manually run './sync-neovim.sh' again. "
