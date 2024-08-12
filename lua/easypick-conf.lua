-- This is plugin is useful so that I can create my custom telescope pickers.
-- Examples: https://github.com/axkirillov/easypick.nvim/wiki

-- More examples here: https://github.com/axkirillov/easypick.nvim/blob/main/lua/easypick/actions.lua

-- How to use:
-- :Easypick <name> (press <Tab> to cycle through available pickers)

-- This allows nvim to not crash if this plugin is not installed.
local status_ok, easypick = pcall(require, "easypick")
if not status_ok then
  return
end

-- only required for the example to work
-- local base_branch = "develop"

-- a list of commands that you want to pick from
-- local list = [[
-- << EOF
-- :Telescope find_files
-- :Git blame
-- EOF
-- ]]

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local current_dir = vim.fn.getcwd()
local recent_files_on_current_folder_command = [[find ]]
    .. current_dir
    ..
    [[ \( -type d -name '.git' -o -type d -name '__pycache__' \) -prune -o -type f -mtime -14 -printf '%T@ %P\n' | sort -rn | cut -d' ' -f2- ]]

-- Add custom pickers here.
local custom_pickers = {
  -- list most recent files with default previewer
  {
    name = "recent_files_on_current_folder",
    command = recent_files_on_current_folder_command,
    previewer = easypick.previewers.default(),
  },
}

easypick.setup({ pickers = custom_pickers })
