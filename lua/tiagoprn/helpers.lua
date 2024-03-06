local command = vim.api.nvim_command

local Job = require("plenary.job")

local M = {}

local open_mode = "split" -- or tabedit, vsplit...

function M.readLines(file)
  local f = io.open(file, "r")
  local lines = f:read("*all")
  f:close()
  return lines
end

function M.get_file_exists(full_file_path)
  local file_exists = vim.fn.findfile(full_file_path)
  if file_exists == nil or file_exists == "" then
    -- vim.notify("full_file_path: " .. full_file_path .. " DOES NOT exist!")
    return false
  else
    -- vim.notify("full_file_path: " .. full_file_path .. " exists!")
    return true
  end
end

function M.writeLine(file, line)
  local f = io.open(file, "a")
  io.output(f)
  io.write(line .. "\n")
  io.close(f)
end

function M.writeLines(file, lines)
  local f = io.open(file, "w")
  io.output(f)

  -- print('Writing processed lines to file...')
  for key, value in ipairs(lines) do
    -- print(key..value..'(type: '..type(value)..')')
    io.write(value .. "\n")
  end

  io.close(f)
end

function M.table_to_str(table)
  -- returns a lua table as a string
  local options = { null = true }
  return vim.inspect(table, options)
end

function M.linuxCommand(commandName, args)
  local exitCode
  local output

  -- print("COMMAND_NAME: " .. commandName .. ", ARGS:" .. M.table_to_str(args))

  Job:new({
    command = commandName,
    args = args,
    on_exit = function(j, returnVal)
      exitCode = returnVal
      output = j:result()
    end,
    timeout = 3000,
  }):sync()

  -- print("RESULT >>> " .. M.table_to_str(output))

  return exitCode, output[1]
end

function M.createTimestampedFileWithSnippet(directoryPath, exCommandsFile)
  local currentDate = os.date("%Y-%m-%d-%H%M%S")
  local suffix = math.random(100, 999)
  local fileName = currentDate .. "-" .. suffix .. ".md"
  local timestampedFile = directoryPath .. "/" .. fileName

  M.linuxCommand("mkdir", { "-p", directoryPath })

  local vimOpenFileCommand = open_mode .. timestampedFile
  command(vimOpenFileCommand)

  local vimExCommands = "source " .. exCommandsFile
  command(vimExCommands)
end

function M.createAlternativeFormatTimestampedFileWithSnippet(directoryPath, exCommandsFile)
  local currentDate = os.date("%Y-%m-%d-%H-%M-%S")
  local fileName = currentDate .. ".md"
  local timestampedFile = directoryPath .. "/" .. fileName
  local vimOpenFileCommand = open_mode .. timestampedFile
  command(vimOpenFileCommand)

  local vimExCommands = "source " .. exCommandsFile
  command(vimExCommands)
end

function M.createSluggedFileWithSnippet(directoryPath, exCommandsFile, slug, post_name)
  local fileName = slug .. ".md"
  local fullFilePath = directoryPath .. "/" .. fileName

  M.linuxCommand("mkdir", { "-p", directoryPath })

  M.writeLine(fullFilePath, post_name)

  local vimOpenFileCommand = open_mode .. fullFilePath
  command(vimOpenFileCommand)

  local vimExCommands = "source " .. exCommandsFile
  command(vimExCommands)
end

function M.slugify(phrase)
  local charmap = {
    [" "] = "-",
    ["/"] = "-",
  }

  for k, _ in pairs(charmap) do
    phrase = phrase:gsub(tostring(k), charmap[k])
  end

  local emptify = "!?'=\""
  for i = 1, #emptify do
    local char = emptify:sub(i, i)
    phrase = phrase:gsub(char, "")
  end

  return string.lower(phrase)
end

function M.string_split(str, pattern)
  -- USAGE:
  -- local str = "abc,123,hello,ok"
  -- local list = string_split(str, ",")
  -- for _, s in ipairs(list) do
  --   print(tostring(s))
  -- end
  --
  local result = {}
  string.gsub(str, "[^" .. pattern .. "]+", function(w)
    table.insert(result, w)
  end)
  return result
end

function M.set(list)
  -- Builds the equivalent of a python's set.
  -- USAGE:
  -- local helpers = require("tiagoprn.helpers")
  -- local items = helpers.set({ "apple", "orange", "pear", "banana" })
  -- if items["orange"] then
  --   print("Orange is on the items!")
  -- else
  --   print("Orange is NOT on the items!")
  -- end

  local set = {}
  for _, value in ipairs(list) do
    set[value] = true
  end
  return set
end

function M.search_on_list(all_items, search_items)
  local set_items = M.set(all_items)
  local found_elements = {}
  for _, element in ipairs(search_items) do
    if set_items[element] then
      table.insert(found_elements, element)
    end
  end
  return found_elements
end

function M.current_window_number()
  return vim.api.nvim_win_get_number(0)
end

function M.show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

function M.get_current_file_relative_path()
  local relative_path = vim.fn.expand("%:~:.")
  return relative_path ~= "" and relative_path or vim.fn.expand("%")
end

function M.tmux_get_current_session_name()
  local exit_code, output = M.linuxCommand("tmux", { "display-message", "-p", "'#S'" })
  -- print("Exit code 1:", exit_code)
  -- print("Output 1:", output)

  local session_name = string.gsub(output, "'", "")
  return session_name
end

function M.tmux_create_or_switch_to_scratchpad_session()
  local current_tmux_session_name = M.tmux_get_current_session_name()

  local scripts_root = "/storage/src/dot_files/tiling-window-managers/scripts/"
  local create_scratchpad_command = scripts_root .. "tmux-create-or-switch-to-scratchpad-session.sh"
  local exit_code, output = M.linuxCommand("bash", { "-c", create_scratchpad_command })

  -- print("Exit code 2:", exit_code)
  -- print("Output 2:", output)

  local scratchpad_session_name = current_tmux_session_name .. "__scratchpad"
  return scratchpad_session_name
end

function M.tmux_run_bash_command_on_scratchpad_session(tmux_session_name, bash_command)
  local scripts_root = "/storage/src/dot_files/tiling-window-managers/scripts/"
  local tmux_run_command_script = scripts_root .. "tmux-run-command-on-other-session-window-and-pane.sh"
  local tmux_scratchpad_session_window = tmux_session_name .. ":0"
  print("script: " .. tmux_run_command_script)
  print("session_window: " .. tmux_scratchpad_session_window)
  print("bash_command: " .. bash_command)

  local exit_code, output = M.linuxCommand(tmux_run_command_script, {
    "--session-window",
    tmux_scratchpad_session_window,
    "--pane",
    "0",
    "--command",
    bash_command,
  })

  -- print("EXIT_CODE 3: " .. exit_code)
  -- print("OUTPUT 3: " .. output)

  return exit_code, output
end

function M.print_table(t, indent, table_history)
  indent = indent or ""
  table_history = table_history or {}

  for k, v in pairs(t) do
    local item = indent .. tostring(k) .. ": "

    if type(v) == "table" and not table_history[v] then
      table_history[v] = true
      print(item)
      print_table(v, indent .. "  ", table_history)
    else
      print(item .. tostring(v))
    end
  end
end

function M.escape_single_quotes(str)
  return string.gsub(str, "'", "'\\''")
end

function M.get_pyproject_toml_path()
  local pyproject_toml_file = "pyproject.toml"
  local default_pyproject_toml = "/storage/src/devops/python/default_configs/pyproject.toml"
  local project_root = vim.fn.getcwd()
  local pyproject_toml_full_path = project_root .. "/" .. pyproject_toml_file

  file_exists = M.get_file_exists(pyproject_toml_full_path)

  if file_exists == false then
    vim.notify("Could not find pyproject.toml, using default one.")
    pyproject_toml_full_path = default_pyproject_toml
  end

  vim.notify("Using pyproject.toml from: " .. pyproject_toml_full_path)

  return pyproject_toml_full_path
end

function M.run_flake8()
  local project_root = vim.fn.getcwd()

  local enable_flake8_file = project_root .. "/" .. "enable-flake8"
  local enable_flake8_file_exists = M.get_file_exists(enable_flake8_file)
  if enable_flake8_file_exists == true then
    local current_file = vim.fn.expand('%')
    local result = vim.fn.systemlist('flake8 --max-line-length=160 ' .. current_file)

    if next(result) ~= nil then
      vim.fn.setqflist({}, ' ', { title = 'Flake8 Errors', lines = result, efm = '%f:%l:%c: %m' })
      vim.cmd('copen')
    else
      vim.cmd('cclose')
    end
  end
end

function M.info_flake8()
  local project_root = vim.fn.getcwd()

  local enable_flake8_file = project_root .. "/" .. "enable-flake8"
  local enable_flake8_file_exists = M.get_file_exists(enable_flake8_file)
  if enable_flake8_file_exists == true then
    vim.notify("enable-flake8 file found on project root, so flake8 will be enabled for this file.")
  else
    vim.notify("enable-flake8 file NOT found on project root, so flake8 will be disabled for this file.")
  end
end

return M
