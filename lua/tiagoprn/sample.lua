-- sample lua functions

local command = vim.api.nvim_command
local fn = vim.fn

local h = require("tiagoprn.helpers")

local M = {} -- creates a new table here to isolate from the global scope

-- This function shows how to run vim commands
function M.welcomeToLua()
  -- command 'enew'  -- equivalent to :enew
  command('echo "Welcome to lua! o/"')
end

function M.runExternalCommand()
  local install_path = fn.stdpath("data") .. "lazy/lazy.nvim"
  command("!ls -lha " .. install_path)
end

function M.checkForErrorsAsBooleanVariable()
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  local lazy_exists = vim.uv.fs_stat(lazy_path) ~= nil
  if lazy_exists then
    vim.cmd('echo "Lazy.nvim exists! o/"')
  else
    vim.cmd('echo "Lazy.nvim DOES NOT exist! :("')
  end
end

function M.complexSample()
  local exCommandFile = vim.fn.stdpath("config") .. "/ex-commands/complex-sample.ex"
  local tempExFileName = "/tmp/quick-note.ex"
  local timestamp = os.date("%H:%M")

  local content = h.readLines(exCommandFile)
  if content == nil then
    vim.notify("Ex commands file not found: " .. exCommandFile, vim.log.levels.ERROR)
    return
  end

  local commands = {}
  for value in content:gmatch("([^\n]*)\n?") do
    value = value:gsub("%_TIMESTAMP_", timestamp)
    table.insert(commands, value)
  end
  h.writeLines(tempExFileName, commands)

  -- local quicknotesDir = '/tmp/quick'
  local quicknotesDir = "/storage/docs/notes/quick"
  h.linuxCommand("mkdir", { "-p", quicknotesDir })

  local currentDate = os.date("%Y-%m-%d")
  local fileName = quicknotesDir .. "/" .. "notes-" .. currentDate .. ".md"

  local vimOpenFileCommand = "tabedit " .. fileName
  command(vimOpenFileCommand)

  local vimExCommands = "source " .. tempExFileName
  command(vimExCommands)
end

return M
