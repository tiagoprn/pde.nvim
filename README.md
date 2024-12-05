# nvim

This repo contains my modular neovim configuration.

It provides a PDE - Personal Development Environment. It was heavily tweaked by my daily use of neovim through the years, so it reflects my workflow and personal preferences on coding and writing. As so, you can use it as-is following this instructions, but you would better take this as a starting point or reference to create your own. I tweak this almost on a daily basis.

I also daily (re)compile nvim from its' master branch, and the simple script I use to do that is mentioned on the next section.

The package manager I use on neovim is "lazy.nvim".

The distro package names below with additional tooling to make this work take into account PopOS! 22.04+ (which derives from Ubuntu), so if you want to use this on any other distro you must use the equivalent names there.

# MANUAL INSTALL/UPGRADE METHOD
(from master branch on github repo - bleeding edge)

## PRE-INSTALL

### 1) Install latest version of node

```bash
$ curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
$ sudo apt install -y nodejs
```

### 2) Install language servers

#### python

To be able to use virtualenvs in python projects but not have to install the library pynvim on each one of them, I can create a pyenv virtualenv called neovim, and install the nvim requirements there. Then, the configuration `g:python3_host_prog` on my `init.vim` will point to the python interpreter that has the integration library. Reference: <https://neovim.io/doc/user/provider.html#python-virtualenv>

E.g. on how to setup that virtualenv (adapted to my workflow):

```bash
$ pyenv virtualenv 3.12.3 neovim
$ pyenv activate neovim
$ pip install -r /storage/src/devops/python/requirements.nvim-lsp  # https://github.com/tiagoprn/devops/blob/master/python/requirements.nvim-lsp
```

That will install not only pynvim, but also other packages related to python LSP on neovim (pylsp - python language server, black, pylint, isort, etc...) on this common environment. If the need arises to use different versions of any of them, I can manually install the libraries listed at <https://github.com/tiagoprn/devops/blob/master/python/requirements.nvim-lsp> on the project's virtualenv.

#### bash

- Bash Language Server:
```bash
# Install
$ sudo npm i -g bash-language-server

# Update bash-language-server.
$ sudo npm update --location=global

# Test bash-language-server.
$ bash-language-server -v
```

- shellcheck: bash linter
```bash
$ sudo apt install -y shellcheck
```

- shfmt: bash formatter for shell scripts:
```bash
$ sudo apt install -y golang-go  # install go if not installed
$ GO111MODULE=on go install mvdan.cc/sh/v3/cmd/shfmt@latest
$ sudo cp ~/go/bin/shfmt /usr/bin/
```

NOTE: Treesitter parsers will be installed when neovim if first started through npm. Commands to inspect that:
```bash
:TSInstallInfo  # List all available languages and their installation status
:TSUpdate       # Updates all parsers
:TSUpdate xyz   # Updates xyz language parser
```

#### lua

- lua-language-server (previously called "sumneko"):
    - Create folder (or delete existing contents on it when updating): `mkdir -p ~/.config/nvim/lua-language-server`
    - Enter folder `~/.config/nvim/lua-language-server`
	- Download a release from this page: <https://github.com/LuaLS/lua-language-server/releases>
    - Uncompress the file with `tar xfzv`
    - Check it is working and the version is the same you downloaded:
    ``` bash
    $ bin/lua-language-server --version
    ```

- stylua: install using rust package manager:
```bash
$ sudo apt install cargo
$ cargo install stylua
# Add the path of the compiled stylua binary returned by the next command to your $PATH:
$ which stylua
```

## INSTALL

1) Make sure you have the followig packages installed on your distro, to make sure you will be able to compile and use nvim with the configuration on this repo:

``` bash

sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen \
    bash-completion bat entr fd-find fzf inotify-tools jq ripgrep sed

```

Then, create the bash aliases needed for some of the utils:


``` bash

sudo ln -s /usr/bin/batcat /usr/bin/bat
sudo ln -s /usr/bin/fdfind /usr/bin/fd


```

2) To setup or get rid (backup) your current configuration first, run the configure_neovim bash script:

``` bash

./scripts/configure_neovim.sh

```

3) Run the script which will download and compile nvim from the master/main branch of its' github repository:

``` bash

./scripts/sync-neovim.sh

```

- Run:
``` bash
$ nvim
```

This will automatically run the "lazy" package manager that will install all packages on nvim. After finished, quit nvim and start it again.

- To see the plugins output: `:messages`, to clear all messages: `:messages clear`

## POST-INSTALL

**IMPORTANT**: On debian's derivative distributions, after installing, you can do the optional step below to link the default and vi editor to nvim:

```bash
$ sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 1 && \
sudo update-alternatives --set editor /usr/local/bin/nvim && \
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 1 && \
sudo update-alternatives --set vi /usr/local/bin/nvim
```

---

## TIPS

### MACROS:

- Record a macro:
```
(NORMAL) q<letter><commands>q
```

(I have the "marvim" plugin installed, which allows persisting macros for use in the future.)

- To execute the macro <number> times (once by default), type:
```
<number-of-times>@<letter>
```

- So, the complete process looks like:
```
qa      - start recording to register a
...	    - your complex series of commands
q	      - stop recording
@a	    - execute your macro
@@	    - execute your macro again
99@a    - execute your macro 99 times
```

### SCRIPT NVIM COMMANDS:
```bash
$ nvim --cmd 'echo "This runs before .vimrc"' -c ':call UltiSnips#ListSnippets()' -c '<Esc>' -c ':q!'
$ nvim -c ':call UltiSnips#ListSnippets()' -c ':q!'
$ nvim +PluginInstall +qall
```

### OTHER

[Here](TIPS.md) are some useful tips on how to do things in neovim - mostly for customizing it through lua - e.g. macros, mappings, telescope pickers, etc.
