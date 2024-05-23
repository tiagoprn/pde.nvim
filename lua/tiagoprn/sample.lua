-- sample lua functions

local command = vim.api.nvim_command
local fn = vim.fn

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
  local lazy_exists = vim.loop.fs_stat(lazy_path) ~= nil
  if lazy_exists then
    vim.cmd('echo "Lazy.nvim exists! o/"')
  else
    vim.cmd('echo "Lazy.nvim DOES NOT exist! :("')
  end
end

function M.complexSample()
  local exCommandFile = "/storage/src/dot_files/nvim/ex-commands/complex-sample.ex"
  local tempExFileName = "/tmp/quick-note.ex"
  local timestamp = os.date("%H:%M")

  local commands = {}
  for value in h.readLines(exCommandFile):gmatch("([^\n]*)\n?") do
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
