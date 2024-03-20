# Neovim customization tips


## `viminfo` on neovim:
- Instead of the viminfo format, neovim uses `shada` files. For more details: `:h shada`. In linux, the default path of this file is: `$HOME/.local/share/nvim/shada/main.shada`.

## Running lua functions:

``` vim
(run below on NORMAL MODE)
:lua require'sample'.runExternalCommand()
:lua require'sample'.checkForErrorsAsBooleanVariable()
:lua require'sample'.welcomeToLua()
```

## Lua functions/plugins development

- Developing lua plugins interactively with a "REPL":

``` vim
:Luapad
```

Example code to test the "REPL":

``` lua
local module_path = "tiagoprn.scratchpad"

require("plenary.reload").reload_module(module_path)
local module = require(module_path)

local shouted = module.shout("hey tiago!")
print(shouted)
```

- Here is a succint page explaining the basics on lua programming: <https://riptutorial.com/lua>

- Where I can find the "extended library" that neovim exposes to lua? To discover the available methods, I can use the autocomplete provided by the lua LSP when writing code on INSERT mode. The following namespaces are available:
```lua
-- neovim lua API:
vim.<C-Space>
vim.api.<C-Space>
vim.fn.<C-Space>

-- my custom modules with other functions:
local helpers = require("tiagoprn.helpers")
local scratchpad = require("tiagoprn.scratchpad")
helpers.<C-Space>
scratchpad.<C-Space>
```

On those namespaces, there are string and list manipulation functions (that I wasted effort reinventing at `tiagoprn.helpers` not knowing that they existed - I must fix that when possible)

- If I receive error "E41: Out of memory!" when opening a file, edit it outside of nvim and save it.

## How export the mappings to an external file:

1. Inside nvim:
```bash
:redir >> ~/mymaps.txt
:map
:redir END
```
2. Starting nvim with the commands above, using "+" to script the commands:
```bash
nvim +"redir >> /tmp/automap.txt" +"map" +"redir END" +"qa!"
```
(you can use `:verbose map` instead of `:map` to get more info on the mappings.)

## Custom telescope pickers

- If I need to create/run more commands or a command palette using telescope pickers to choose from a list, I can create them on `lua/easypick-conf.lua` (I have examples there and one picker I created to run make commands using harpoon.)

## Place with lots of neovim configs I can analyze

<https://dotfyle.com/>

## How to program <ESC> on a macro:

When recording, just press <ESC>.

When editing the macro [^1] , type: "[Ctrl+b]Esc". It must be on another color so we can make sure it worked.

[^1] Macros are on registers. When I record macro "a", to get its contents I can get the register "a" value.

## Create custom commands to integrate on the editor

Instead of using "Code Actions", I can use the "flow" plugin to run some lua+bash code to create my own ones. It is on the "automations" -> "flow" section of my setup.
