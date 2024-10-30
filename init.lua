-- --- MAIN SETTINGS

-- Rebind <Leader> key
vim.g.mapleader = " "

vim.cmd("syntax on")

vim.o.title = true
vim.o.history = 1000 -- remember more commands and search history

-- Persistent undo
vim.o.undodir = vim.fn.getenv("HOME") .. "/.config/nvim/undodir"
vim.o.undofile = true

vim.o.wildignore = "*.swp,*.bak,*.pyc,*~"

vim.wo.relativenumber = true -- Changing the ruler position
vim.wo.number = true -- show line numbers

vim.opt.formatoptions:append("j") -- Remove comment leader when joining comment lines

-- When the cursor moves outside the viewport of the current window, the buffer scrolls a single
-- line to keep the cursor in view. Setting the option below will start the scrolling x lines
-- before the border, keeping more context around where you’re working.
vim.o.scrolloff = 3

-- Change the sound beep on errors to screen flashing
vim.o.visualbell = true

-- Height of the command bar
vim.o.cmdheight = 1

-- Default updatetime 4000ms is not good for async update
vim.o.updatetime = 100

-- Timeout configurations
vim.o.timeout = true
vim.o.timeoutlen = 300

-- CLIPBOARD CONFIGURATION
if vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
  -- Use wl-copy and wl-paste if available
  vim.o.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
    cache_enabled = 0,
  }
elseif vim.fn.executable("tmux") == 1 and vim.env.TMUX ~= nil then
  -- Use tmux clipboard commands if tmux is installed and inside a tmux session
  vim.o.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = "tmux load-buffer -",
      ["*"] = "tmux load-buffer -",
    },
    paste = {
      ["+"] = "tmux save-buffer -",
      ["*"] = "tmux save-buffer -",
    },
    cache_enabled = 0,
  }
else
  -- Fallback to default clipboard behavior
  vim.o.clipboard = ""
  vim.g.clipboard = nil
end

-- Disable backup and swap files - they trigger too many events for file system watchers
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Better Searching
vim.o.hlsearch = true -- Highlight searches
vim.o.incsearch = true -- Show search matches while you type
vim.o.ignorecase = true -- Ignore case on searching by default
vim.o.smartcase = true -- Uppercase characters will be taken into account

vim.o.listchars = "tab:→␣,space:·,nbsp:␣,trail:•,eol:↩,precedes:«,extends:»"

vim.o.completeopt = "menu,menuone,noselect"

-- Enable true colors theme support
vim.o.termguicolors = true

-- Cursor to stay in the middle line of the screen when possible
-- vim.o.so = 999

-- Avoids updating the screen before commands are completed
-- vim.o.lazyredraw = true

-- OVERRIDING COLORS
-- Do that here: 'after/plugin/all.lua'

-- TODO: move below to 'after/plugin/all.lua'
-- Highlight current line
vim.o.cursorline = true
vim.cmd("hi CursorLine cterm=none term=none")
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  pattern = "*",
  command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  pattern = "*",
  command = "setlocal nocursorline",
})
vim.cmd("highlight CursorLine guibg=#c0c0c0 ctermbg=238")

-- Highlight current column
vim.o.cursorcolumn = true
vim.cmd("hi CursorColumn cterm=none term=none")
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  pattern = "*",
  command = "setlocal cursorcolumn",
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  pattern = "*",
  command = "setlocal nocursorcolumn",
})
vim.cmd("highlight CursorColumn guibg=#303000 ctermbg=238")

-- --- Configure rg integration
vim.o.grepprg = "rg --vimgrep"
vim.opt.grepformat:prepend("%f:%l:%c:%m")

-- Custom winbar
-- Right size, file has changed, file path
-- vim.o.winbar = '%=%m %F'

-- --- Splits defaults
-- Open vertical splits on the right side
vim.o.splitright = true
-- Open horizontal splits below
vim.o.splitbelow = true

-- --- Allows reloading the quickfix after modifying it
-- --- (https://www.reddit.com/r/vim/comments/7dv9as/how_to_edit_the_vim_quickfix_list/)
-- vim.opt_local.errorformat = '%f|%l col %c|%m'

-- --- Setup Python virtualenv that has Neovim requirements installed
-- Check this repository README.md for details
vim.g.python3_host_prog = "~/.pyenv/versions/neovim/bin/python"

-- --- OTHER SETTINGS

-- Source additional Vimscript files
-- TODO: these need to be converted to Lua)
vim.cmd("source $HOME/.config/nvim/functions.vim")
vim.cmd("source $HOME/.config/nvim/commands.vim")
vim.cmd("source $HOME/.config/nvim/abbreviations.vim")
vim.cmd("source $HOME/.config/nvim/hooks.vim")

-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Latest stable release
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

-- custom commands
require("tiagoprn.custom_commands")

-- --- PLUGINS

require("plugins")
require("surround-conf")
require("nvim-cmp")
-- require('lua-lsp')
require("python-lsp")
require("ruff-lsp")
require("bash-lsp")
require("lsp-saga")
require("setup-null-ls")
require("treesitter-conf")
require("tree")
-- require('catppuccin-colors')
require("autopairs")
require("snippets")
require("aerial-code-navigation")
require("telescope-conf")
require("gitsigns-conf")
require("luapad-conf")
require("lualine-conf")
require("comment-conf")
require("highlight-colors-conf")
require("lsp-colors-conf")
require("zen-conf")
require("easypick-conf")
require("treesitter-context-conf")
require("treesitter-textobjects-conf")
require("smooth-cursor-conf")
require("dressing-conf")
require("buffer_manager-conf")
require("goto-preview-conf")
require("mind-conf")
require("noice-conf")
require("key-mappings-conf")
require("todo-conf")
-- require('flow-conf')
require("blame-conf")
require("markview-conf")
require("bookmarks-conf")
require("obsidian-conf")

-- Source additional Vimscript plugin configurations
-- TODO: these need to be converted to Lua
vim.cmd("source $HOME/.config/nvim/conf-plugins/marvim.vim")
vim.cmd("source $HOME/.config/nvim/conf-plugins/conceals.vim")
vim.cmd("source $HOME/.config/nvim/conf-plugins/navigator.vim")
vim.cmd("source $HOME/.config/nvim/conf-plugins/asyncrun.vim")

vim.cmd("source $HOME/.config/nvim/commands-tiagoprn-functions.vim")

-- AUTOGROUPS
-- Below overrides MAIN SETTINGS section configuration, according to the file type
-- TODO: These Vimscript files need to be converted to Lua
vim.cmd("source $HOME/.config/nvim/augroups/python.vim")
vim.cmd("source $HOME/.config/nvim/augroups/lua.vim")
vim.cmd("source $HOME/.config/nvim/augroups/quickfix.vim")
vim.cmd("source $HOME/.config/nvim/augroups/json.vim")
vim.cmd("source $HOME/.config/nvim/augroups/misc.vim")
vim.cmd("source $HOME/.config/nvim/augroups/completion.vim")
vim.cmd("source $HOME/.config/nvim/augroups/html.vim")
vim.cmd("source $HOME/.config/nvim/augroups/txt.vim")
