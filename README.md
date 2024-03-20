# nvim

This repo contains my modular neovim configuration.

It provides a PDE - Personal Development Environment. It was heavily tweaked by my daily use of neovim through the years, so it reflects my workflow and personal preferences on coding and writing. As so, you can use it as-is following this instructions, but you would better take this as a starting point or reference to create your own. I tweak this almost on a daily basis.

I also daily (re)compile nvim from its' master branch, and the simple script I use to do that is mentioned on the next section.

The package manager I use on neovim is "packer" - for now, I will migrate to "lazy.nvim" soon.

The distro package names below with additional tooling to make this work take into account PopOS! 22.04+ (which derives from Ubuntu), so if you want to use this on any other distro you must use the equivalent names there.


## MANUAL INSTALL/UPGRADE METHOD
(from master branch on github repo - bleeding edge)

**IMPORTANT**: if you wish before to get rid (backup) your current configuration first, run my [configure_neovim bash script](./scripts/configure_neovim.sh)

Run [my sync-neovim bash script](./scripts/sync-neovim.sh)

**IMPORTANT**: On debian's derivative distributions, after installing, you can do the optional step below to link the default and vi editor to nvim:

```bash
$ update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 1 && \
update-alternatives --set editor /usr/local/bin/nvim && \
update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 1 && \
update-alternatives --set vi /usr/local/bin/nvim
```

## CONFIGURATION

### 1) Install latest version of node

```bash
$ curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
$ sudo apt install -y nodejs
```

### 2) Install language servers

#### python

To be able to use virtualenvs in python projects but not have to install the library pynvim on each one of them, I can create a virtualenv called neovim (e.g. on python 3.10+), and install the nvim requirements there. Then, the configuration `g:python3_host_prog` on my `init.vim` will point to the python interpreter that has the integration library. Reference: <https://neovim.io/doc/user/provider.html#python-virtualenv>

E.g. on how to setup that virtualenv (adapted to my workflow):

```bash
$ pyenv virtualenv 3.10.4 neovim
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

NOTE: Treesitter parsers will be installed through npm. Commands to inspect that:
```bash
:TSInstallInfo  # List all available languages and their installation status
:TSUpdate       # Updates all parsers
:TSUpdate xyz   # Updates xyz language parser
```

#### lua

- lua-language-server (previously called "sumneko"):
    - Create folder (or delete existing contents on it when updating): `~/.config/nvim/lua-language-server`
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

### 3) Setting up neovim

- **IMPORTANT:** Before starting:
    - make sure you already have neovim installed (as appimage or compiled).
    - make sure you have installed the language servers and related programs/packages of the previous sections.
    - make sure you have the following packages installed on your distro: `bash-completion bat entr fd fzf gitui inotify-tools jq ripgrep sed`

- To (re)set your environment, run <./scripts/configure_neovim.sh>. It will delete the existing environment and clone the packer repo.

- Run:
```
$ nvim
<ESC> :PackerCompile <ENTER>
<ESC> :PackerSync <ENTER>
```

- To see the plugins output: `:messages`, to clear all messages: `:messages clear`

## MACROS:

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

## SCRIPT NVIM COMMANDS:
```bash
$ nvim --cmd 'echo "This runs before .vimrc"' -c ':call UltiSnips#ListSnippets()' -c '<Esc>' -c ':q!'
$ nvim -c ':call UltiSnips#ListSnippets()' -c ':q!'
$ nvim +PluginInstall +qall
```

## OTHER

[Here](TIPS.md) are some useful tips on how to do things in neovim - mostly for customizing it through lua - e.g. macros, mappings, telescope pickers, etc.
