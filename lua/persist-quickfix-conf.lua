-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, persist_quickfix = pcall(require, "persist-quickfix")
if not status_ok then
  return
end

local M = {}

function M.save()
  -- Get the current working directory
  local cwd = vim.fn.getcwd()
  -- Extract the root directory from the CWD
  local root_dir = cwd:match("([^/]+)$")
  -- Get the current timestamp
  local timestamp = os.date("%Y%m%d-%H%M%S")
  -- Get user input for the quickfix name
  local input = vim.fn.input("Enter the quickfix name: ")
  -- Check if the user provided an input
  if input ~= "" then
    -- Concatenate root directory with timestamp and user input as the quickfix name
    local quickfix_name = root_dir .. "." .. timestamp .. "." .. input

    -- Save the quickfix with the new name
    persist_quickfix.save(quickfix_name)
  else
    print("No input provided.")
  end
end

function M.load()
  persist_quickfix.choose()
end

function M.delete()
  persist_quickfix.choose_delete()
end

return M
