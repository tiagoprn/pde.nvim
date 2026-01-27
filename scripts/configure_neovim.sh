#!/usr/bin/env bash
set -e

TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')

removeDirIfPresent() {
  if [[ -d $1 ]]; then
    rm -rf "$1"
    echo "Removed dir '$1'"
  fi
}

removeSymbolicLinkIfPresent() {
  if [[ -f $1 ]]; then
    rm "$1"
    echo "Removed symlink '$1'"
  fi
}

renameDirIfPresent() {
  if [[ -d $1 ]]; then
    mv "$1" "$1.$TIMESTAMP"
    echo "Renamed '$1' to '$1.$TIMESTAMP'."
  fi
}

removeConfiguration() {
  removeDirIfPresent ~/.config/nvim
  removeDirIfPresent ~/.local/share/nvim
  removeDirIfPresent ~/.local/state/nvim
  removeDirIfPresent ~/.cache/nvim
}

backupConfiguration() {
  renameDirIfPresent ~/.config/nvim
  renameDirIfPresent ~/.local/share/nvim
  renameDirIfPresent ~/.local/state/nvim
  renameDirIfPresent ~/.cache/nvim
}

# echo 'Deleting old setup (if it exists)...'
# removeConfiguration

echo 'Backing up old setup (if it exists)...'
backupConfiguration

echo 'Recreating setup using symlinks from my dot_files repo...'
mkdir -p ~/.config || true
removeSymbolicLinkIfPresent rm ~/.config/nvim
ln -s /storage/src/pde.nvim ~/.config/nvim

echo 'DONE.'
