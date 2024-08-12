#!/usr/bin/env bash

# This script (re)compiles neovim from its official repository.
#
# Below is an example on how to use it with custom paths for the source and the binary:
#
# 	$ ./sync-neovim.sh  --source-path $HOME/src/nvim --binary-path $HOME/local/bin/nvim
#
# ** IMPORTANT ** : For this script to work with the arguments, --binary-path MUST finish with "/bin/nvim", no matter with subpath you choose before.

NVIM_SOURCES_PATH=/opt/src/neovim
NVIM_BINARY_PATH=/usr/local/bin/nvim

while [[ $# -gt 0 ]]; do
    case $1 in
        --source-path)
            NVIM_SOURCES_PATH="$2"
            shift
            ;;
        --binary-path)
            NVIM_BINARY_PATH="$2"
            shift
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;
    esac
    shift
done

mkdir -p "$NVIM_SOURCES_PATH"
mkdir -p "$(dirname "$NVIM_BINARY_PATH")"

NVIM_REPO_URL="https://github.com/neovim/neovim.git"

# Check if the directory is empty or doesn't exist
if [ ! -e "$NVIM_SOURCES_PATH" ] || [ -d "$NVIM_SOURCES_PATH" ] && [ -z "$(ls -A "$NVIM_SOURCES_PATH")" ]; then
    echo "The directory $NVIM_SOURCES_PATH is empty. Cloning Neovim repository..."
    git clone "$NVIM_REPO_URL" "$NVIM_SOURCES_PATH"
else
    echo "$NVIM_SOURCES_PATH is not empty. Moving on..."
fi

# Cleanup existing install and compile a new one
PREVIOUS_VERSION=$(sudo -- bash -c "cd $NVIM_SOURCES_PATH && git log -n 1 --pretty=format:'%cD by %an (%h)'")

BACKUPS_ROOT=$NVIM_SOURCES_PATH/tmp/OLD-VERSIONS-ARCHIVE
SUFFIX="$(date +%Y%m%d-%H%M%S-%N)"
BACKUPS_DIR=$BACKUPS_ROOT/$SUFFIX
PLUGINS_DIR=$HOME/.local/share/nvim/lazy

sudo mkdir -p $BACKUPS_DIR
sudo cp -farv $NVIM_BINARY_PATH $BACKUPS_DIR
sudo bash -c 'echo -e "# INSTRUCTIONS\n\n- The plugins must be restored to: <[USER_HOME]/.local/share/nvim/lazy>;\n- They must be unpacked using sudo;\n- Change the owner for all of them to [USER] ." > '"$BACKUPS_DIR"'/README.md'
sudo tar cjvf $BACKUPS_DIR/home_plugins_archive.tar.bz2 -C $PLUGINS_DIR $(cd $PLUGINS_DIR && find . -type f -print) # the -C option is to enter the path and only include the pattern files that follow on the archive, not their original paths
echo -e "\n-----\nThe old nvim binary and an archive with the plugins used with them were copied to $BACKUPS_DIR in case you need to manually revert it."

echo "Compiling nvim (this will take a while)..."
echo -e "\033[0;31mIf the build fails for any reason, run the script \n'/storage/src/pde.nvim/scripts/nvim-clean-cmake-build-cache.sh'\n to delete cmake cache and rebuild from a pristine state.\033[0m"
read -n 1 -s -r -p "Press any key to continue..."

echo "==> Using source path: $NVIM_SOURCES_PATH"
echo "==> Using binary path: $NVIM_BINARY_PATH"

case "$NVIM_BINARY_PATH" in
    /opt*)
        echo "==> BUILDING FROM /OPT"
        COMMANDS="cd $NVIM_SOURCES_PATH && git fetch && git pull && rm -fr $NVIM_SOURCES_PATH/build && make clean && make CMAKE_BUILD_TYPE=Release && make install"
        ;;

    *)
        echo "==> BUILDING FROM OTHER"
        BUILD_PREFIX="${NVIM_BINARY_PATH%/bin/nvim}"
        COMMANDS="cd $NVIM_SOURCES_PATH && git fetch && git pull && rm -fr $NVIM_SOURCES_PATH/build && make clean && make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS='-DCMAKE_INSTALL_PREFIX=$BUILD_PREFIX' && make install"
        ;;
esac

sudo -- bash -c "$COMMANDS"

NEW_VERSION=$(sudo -- bash -c "cd $NVIM_SOURCES_PATH && git log -n 1 --pretty=format:'%cD by %an (%h)'")

message="\nFinished compiling nvim.\n\nPrevious version:\n\t$PREVIOUS_VERSION\nNew version:\n\t$NEW_VERSION\n\nHave fun! \o/"
echo "-----------------"
echo -e "$message"
echo "-----------------"
