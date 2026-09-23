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

### 2) Treesitter

Install treesitter CLI:

```bash

cargo install --locked tree-sitter-cli

```

To validate treesitter parsers installation: `:checkhealth treesitter`

NOTE: Treesitter parsers will be installed when neovim if first started through npm. Commands to inspect that:
```bash
:TSInstallInfo  # List all available languages and their installation status
:TSUpdate       # Updates all parsers
:TSUpdate xyz   # Updates xyz language parser
```


### 3) Install language servers

#### python

To be able to use virtualenvs in python projects but not have to install the library pynvim on each one of them, I can create a pyenv virtualenv called neovim, and install the nvim requirements there. Then, the configuration `vim.g.python3_host_prog` on my `init.lua` will point to the python interpreter that has the integration library. Reference: <https://neovim.io/doc/user/provider.html#python-virtualenv>

E.g. on how to setup that virtualenv (adapted to my workflow):

```bash

# using uv
$ uv venv --python 3.12 $HOME/.pyenv/versions/neovim
$ source $HOME/.pyenv/versions/neovim/bin/activate
$ uv pip install -r /storage/src/devops/python/requirements.nvim-lsp  # https://github.com/tiagoprn/devops/blob/master/python/requirements.nvim-lsp

# using pyenv
$ pyenv virtualenv 3.12.3 neovim
$ pyenv activate neovim
$ pip install -r /storage/src/devops/python/requirements.nvim-lsp  # https://github.com/tiagoprn/devops/blob/master/python/requirements.nvim-lsp

```

That will install not only pynvim, but also other packages related to python LSP on neovim (pylsp - python language server, black, pylint, isort, etc...) on this common environment. If the need arises to use different versions of any of them, I can manually install the libraries listed at <https://github.com/tiagoprn/devops/blob/master/python/requirements.nvim-lsp> on the project's virtualenv.

Install `ty` LSP:

```bash

uv tool install ty@latest

```


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

#### lua

- lua-language-server (previously called "sumneko"):
    - install with the nix package manager (see my repo <https://github.com/tiagoprn/nix-home-manager/blob/4541cc1d77d2aeae962d1620059b515760bb9b36/packages_list.nix#L8>)

- stylua: install using rust package manager:
```bash
$ sudo apt install cargo
$ cargo install stylua
# Add the path of the compiled stylua binary returned by the next command to your $PATH:
$ which stylua
```

#### kotlin

- kotlin-language-server (community Kotlin LSP, used by `lua/kotlin-lsps.lua`):
```bash
# Install JDK 21, used ONLY by this language server: its bundled Kotlin compiler 2.1.0
# rejects Java 25 (java.lang.IllegalArgumentException in JavaVersion.parse).
# This does NOT interfere with the JAVA_HOME=25 set in ~/.bashrc: the pin is applied
# per-process via cmd_env in lua/kotlin-lsps.lua (Gradle/adb/shell still use JDK 25).
$ sudo pacman -S --needed jdk21-openjdk

# Download the latest release (check https://github.com/fwcd/kotlin-language-server/releases for updates).
$ wget -O /tmp/kotlin-language-server.zip https://github.com/fwcd/kotlin-language-server/releases/download/1.3.13/server.zip

# Extract under ~/.local/share.
$ mkdir -p ~/.local/share/kotlin-language-server
$ unzip -o /tmp/kotlin-language-server.zip -d ~/.local/share/kotlin-language-server

# Symlink the binary onto PATH.
$ ln -sf ~/.local/share/kotlin-language-server/server/bin/kotlin-language-server ~/.local/bin/kotlin-language-server

# Test kotlin-language-server (it has no --version/--help flags; it boots and reads LSP on stdin).
$ echo | timeout 5 kotlin-language-server
```

  Validate the JDK pin (server on 21, everything else on 25):
```bash
$ echo "JAVA_HOME=$JAVA_HOME"                       # /usr/lib/jvm/java-25-openjdk (unchanged)
$ java -version                                     # openjdk 25.0.4.1 (Gradle's JDK)
$ JAVA_HOME=/usr/lib/jvm/java-21-openjdk kotlin-language-server < /dev/null 2>/dev/null | grep -o 'Version 1.3.13'
```

##### kotlin-language-server: AGP 9 classpath patch (reapply after every kotlin-language-server update)

**WHAT.** The Gradle import script that kotlin-language-server runs on your project,
`projectClassPathFinder.gradle`, is bundled inside the server jar
`~/.local/share/kotlin-language-server/server/lib/shared-1.3.13.jar`. We replaced it with
the patched copy stored in this repo at `patches/projectClassPathFinder.AGP9.gradle`. The
patch (1) finds `android.jar` from your SDK location instead of calling the removed
`project.android.getBootClasspath()`, (2) collects dependency jars from every resolvable
Gradle configuration whose name ends in `compileclasspath`, using a snapshot list, and
(3) wraps each branch in `try/catch` so one failure can no longer abort the whole import.

**WHY.** When you open an Android Kotlin project (for example
`app/src/main/java/.../MainActivity.kt`), every `android.*` symbol showed
`Unresolved reference`. Context for Android beginners: classes like `android.app.Activity`
and `android.widget.TextView` do not live in your source tree. They live in `android.jar`
inside your Android SDK (here
`~/android-sdk/platforms/android-36/android.jar`), and the language server must be told
that jar is on your classpath. It learns this by running a Gradle import, and that import
failed:

```
> Could not find method getBootClasspath() for arguments [] on object of type
  com.android.build.gradle.internal.dsl.ApplicationExtensionImpl$AgpDecorated.
```

AGP 9 (your project uses 9.4.1) removed that old API, so the import aborted and the
server stored a one-jar classpath (only `kotlin-stdlib`) in `kls_database.db`. Result:
nothing from the Android SDK could resolve. Upstream issue:
https://github.com/fwcd/kotlin-language-server/issues/487 (open on 2026-09-23; server
1.3.13 ships no fix). This is not caused by the JDK 21 pin: the same failure happens
with JDK 25.

**HOW to recreate the fix.** You need this only when kotlin-language-server is updated,
because a fresh `server.zip` overwrites the patched jar. The file name inside the jar
must be exactly `projectClassPathFinder.gradle`, while this repo stores it under its
descriptive name, so the copy step in (2) matters.

1. Back up the jar that contains the script. **Version note:** the file name carries the
   server version (`shared-1.3.13.jar` today). After an update, find the current name
   with the `ls` line below and use it in every command.

```bash
ls ~/.local/share/kotlin-language-server/server/lib/shared-*.jar   # shows the current version
TS=$(date +%Y%m%d-%H%M%S)
JAR=~/.local/share/kotlin-language-server/server/lib/shared-1.3.13.jar  # adjust version if needed
cp -v "$JAR" "$JAR.BKP.$TS"
```

2. Stage the patched script under the name the jar expects, then inject it.

```bash
cp /path/to/pde.nvim/patches/projectClassPathFinder.AGP9.gradle /tmp/projectClassPathFinder.gradle
cd /tmp && zip -q "$JAR" projectClassPathFinder.gradle
diff <(unzip -p "$JAR" projectClassPathFinder.gradle) \
     /path/to/pde.nvim/patches/projectClassPathFinder.AGP9.gradle && echo "PATCH OK"
```

3. Force a fresh import in your Android project. The database is an untracked cache, so
   rename it (do not delete it).

```bash
cd /path/to/android-hello
mv -v kls_database.db kls_database.db.TO-BE-DELETED
```

4. Verify the import task itself before touching Neovim. Expected output: a line
   containing `platforms/android-36/android.jar` and a final `BUILD SUCCESSFUL`.

```bash
cd /path/to/android-hello
JAVA_HOME=/usr/lib/jvm/java-21-openjdk ./gradlew -I /tmp/projectClassPathFinder.gradle \
    kotlinLSPProjectDeps --console=plain 2>&1 | grep -E 'android\.jar|BUILD'
```

   The `JAVA_HOME` here only mirrors the per-process pin from `lua/kotlin-lsps.lua`; the
   script does not depend on it.

5. Restart the language server in Neovim (`:LspRestart`, or restart Neovim). First import
   on a fresh cache takes a few seconds. Then confirm it worked:

```vim
:LspInfo                                  " kotlin_language_server attached to the .kt buffer
```

   Open `MainActivity.kt`: the `Unresolved reference` lines under the `android.*` imports
   must be gone. A new `kls_database.db` appears in the project root, and
   `sqlite3 kls_database.db 'SELECT COUNT(*) FROM ClassPathCacheEntry;'` should return
   more than 1.

- ktlint: Kotlin linter and formatter (registered as a none-ls source in `lua/setup-none-ls.lua`, formats on save):
```bash
# Download the self-executing binary (check https://github.com/ktlint/ktlint/releases for updates).
$ wget -O ~/.local/bin/ktlint https://github.com/ktlint/ktlint/releases/download/1.8.0/ktlint
$ chmod +x ~/.local/bin/ktlint

# Test ktlint.
$ ktlint --version
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
