-- POTENTIAL FUTURE ENHANCEMENTS:
--   1. **Remote Debugging Support**: Add configurations for attaching to remotely running Python processes
--   2. **Conditional Breakpoints UI**: Add keybindings or functions to easily set conditional breakpoints
--   3. **Custom Variable Display**: Enhance how complex variables are displayed in the UI
--   4. **Log Points**: Add support for log points (breakpoints that log information without stopping execution)
--   5. **Uncomment the Web Framework Configurations**: Enable the Flask/Django/FastAPI configurations if you work with these frameworks

local status_ok, dap_python = pcall(require, "dap-python")
if not status_ok then
  return
end

local M = {}

local dap = require("dap")
-- local dapui = require("dapui")
local dapview = require("dap-view")

local dap_vt = require("nvim-dap-virtual-text")

local log_path = vim.fn.expand("~/.cache/nvim/dap.log")
dap.set_log_level("TRACE") -- Set to 'TRACE' for maximum verbosity
vim.notify("DAP logs (by default) are be written to: " .. log_path, vim.log.levels.INFO)

-- HELPER FUNCTIONS

local function get_project_python_path()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv then
    vim.notify("DAP: project virtualenv python path: " .. venv, vim.log.levels.INFO)
    return venv .. "/bin/python"
  else
    vim.notify("DAP: no project virtualenv python path found, using system python", vim.log.levels.WARN)
    return vim.fn.exepath("python")
  end
end

local function get_debugpy_python_path()
  local project_python_path = get_project_python_path()

  -- if I can import debugpy from project_python_path, return project_python_path
  local cmd = project_python_path .. " -c \"import debugpy; print('debugpy_available')\" 2>/dev/null"
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  if result:find("debugpy_available") then
    vim.notify("Using debugpy from PROJECT: " .. project_python_path, vim.log.levels.INFO)
    return project_python_path
  end

  local neovim_venv_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/python")
  vim.notify("Using debugpy from NEOVIM VENV: " .. neovim_venv_path, vim.log.levels.INFO)
  return neovim_venv_path
end

local function get_current_test_name()
  -- Get the current node under cursor using Treesitter
  local current_node = vim.treesitter.get_node()
  if not current_node then
    vim.notify("No treesitter node found at cursor position", vim.log.levels.WARN)
    return nil
  end

  -- Navigate up the tree to find either a function definition or a method definition
  local node = current_node
  local is_method = false
  local class_name = nil

  while node do
    local node_type = node:type()

    -- Check if we're in a method definition
    if node_type == "function_definition" then
      -- Found a function, check if it's inside a class
      local parent = node:parent()
      if parent and parent:type() == "class_definition" then
        is_method = true

        -- Get the class name
        for i = 0, parent:child_count() - 1 do
          local child = parent:child(i)
          if child and child:type() == "identifier" then
            class_name = vim.treesitter.get_node_text(child, 0)
            break
          end
        end
      end
      break
    elseif node_type == "class_definition" then
      -- If we're directly on a class definition, store it and continue looking for a method
      class_name = nil
      for i = 0, node:child_count() - 1 do
        local child = node:child(i)
        if child and child:type() == "identifier" then
          class_name = vim.treesitter.get_node_text(child, 0)
          break
        end
      end
    end

    node = node:parent()
  end

  if not node then
    vim.notify("No function or method definition found", vim.log.levels.WARN)
    return nil
  end

  -- Get the function/method name
  local func_name = nil
  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    if child and child:type() == "identifier" then
      func_name = vim.treesitter.get_node_text(child, 0)
      break
    end
  end

  if not func_name then
    vim.notify("No function or method name found", vim.log.levels.WARN)
    return nil
  end

  -- Check if it's a test function/method (starts with 'test_')
  if func_name:match("^test_") then
    if is_method and class_name then
      -- For methods, return both class and method name for pytest
      local full_name = class_name .. "::" .. func_name
      vim.notify("Found test method: " .. full_name, vim.log.levels.INFO)
      return full_name
    else
      -- For standalone functions
      vim.notify("Found test function: " .. func_name, vim.log.levels.INFO)
      return func_name
    end
  elseif class_name and class_name:match("^Test") then
    -- If the class name starts with "Test" but the method doesn't start with "test_",
    -- it might still be a test method in some frameworks
    local full_name = class_name .. "::" .. func_name
    vim.notify("Found potential test method in test class: " .. full_name, vim.log.levels.INFO)
    return full_name
  end

  vim.notify("No test function or method name found", vim.log.levels.WARN)
  return nil
end

local function get_pytest_root_dir()
  -- Searches for a file named "nvim-dap-pytest-rootdir",
  -- which contains the name of the pytest root dir
  -- we need to explicitly put it on the pytest command.

  -- Try to find the root dir file in the current directory or any parent directory
  local current_dir = vim.fn.getcwd()
  local root_dir_file = "nvim-dap-pytest-rootdir"

  -- Check if the file exists in the current directory
  local file_path = current_dir .. "/" .. root_dir_file
  if vim.fn.filereadable(file_path) == 1 then
    local file = io.open(file_path, "r")
    if file then
      local content = file:read("*all"):gsub("%s+$", "") -- Trim whitespace
      file:close()
      if content and content ~= "" then
        vim.notify("Found pytest root dir: " .. content, vim.log.levels.INFO)
        return content
      end
    end
  end

  -- Check parent directories (up to 5 levels)
  local dir = current_dir
  for i = 1, 5 do
    dir = vim.fn.fnamemodify(dir, ":h") -- Get parent directory
    file_path = dir .. "/" .. root_dir_file
    if vim.fn.filereadable(file_path) == 1 then
      local file = io.open(file_path, "r")
      if file then
        local content = file:read("*all"):gsub("%s+$", "") -- Trim whitespace
        file:close()
        if content and content ~= "" then
          vim.notify("Found pytest root dir: " .. content, vim.log.levels.INFO)
          return content
        end
      end
    end
  end

  -- No root dir file found, return nil
  vim.notify("No pytest root dir file found, using default behavior", vim.log.levels.INFO)
  return nil
end

-- CONFIGURATION

vim.notify("Configuring DAP...[WAIT]", vim.log.levels.INFO)

dap.adapters.python = {
  type = "executable",
  command = get_debugpy_python_path(),
  args = { "-m", "debugpy.adapter" },
  options = {
    timeout = 30000, -- Timeout in milliseconds (30 seconds)
  },
}

-- dapui.setup({
--   layouts = {
--     {
--       elements = {
--         { id = "scopes", size = 0.40 },
--         { id = "watches", size = 0.40 },
--         { id = "breakpoints", size = 0.20 },
--         -- { id = "stacks", size = 0.25 },
--       },
--       size = 40,
--       position = "left",
--     },
--     {
--       elements = {
--         { id = "console", size = 1.0 },
--       },
--       size = 0.2, -- 20% window height
--       position = "bottom",
--     },
--     {
--       elements = {
--         { id = "repl", size = 1.0 },
--       },
--       size = 0.2, -- 20% window height
--       position = "top",
--     },
--   },
-- })

dap_vt.setup({
  commented = true, -- Show virtual text alongside comment
  enabled = true,
  all_frames = true,
  virt_text_pos = "eol",
})

-- mfussenegger/nvim-dap-python:
dap_python.setup(get_debugpy_python_path())
dap_python.test_runner = "pytest"

vim.notify("Configuring DAP...[DONE]", vim.log.levels.INFO)

-- DAP CONFIGURATIONS (PROFILES TO RUN DAP)

dap.configurations.python = dap.configurations.python or {}

table.insert(dap.configurations.python, {
  -- This configuration is the simplest one.
  -- It can be used to validate dap is working to work on an pre-existing python file.
  name = "Debug Sample File",
  type = "python",
  request = "launch",
  program = "/storage/src/pde.nvim/python/dap_test.py", -- Hardcoded file path
  pythonPath = get_project_python_path(),
  dap_python_debugger = get_debugpy_python_path(),
  timeout = 60000, -- 60 seconds timeout for this specific configuration
})

table.insert(dap.configurations.python, {
  name = "Debug Current File",
  type = "python",
  request = "launch",
  program = vim.fn.expand("%:p"), -- Directly expand the current file path
  pythonPath = get_project_python_path(),
  dap_python_debugger = get_debugpy_python_path(),
  timeout = 60000, -- 60 seconds timeout for this specific configuration
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Pytest: Current File",
  module = "pytest", -- Use module instead of program
  args = function()
    local file_name = vim.fn.expand("%:t") -- Get just the filename with extension
    vim.notify("Running pytest on file: " .. file_name, vim.log.levels.INFO)

    local args = {}

    -- If root dir is specified, add it as the first argument
    local root_dir = get_pytest_root_dir()
    if root_dir then
      table.insert(args, root_dir)
      vim.notify("Using pytest root dir: " .. root_dir, vim.log.levels.INFO)
    end

    -- Add the standard pytest options after the root dir
    table.insert(args, "-s") -- Allow print statements and interactive prompts
    table.insert(args, "-vvv") -- Very verbose output
    table.insert(args, "--no-header") -- Reduce header noise
    table.insert(args, "--no-summary") -- Reduce summary noise
    table.insert(args, "--capture=no") -- Don't capture stdout (allows interactive input)

    -- Use -k with the filename to filter tests
    table.insert(args, "-k")
    table.insert(args, file_name)

    return args
  end,
  console = "integratedTerminal", -- This is crucial for interactive debugging
  pythonPath = get_project_python_path(),
  dap_python_debugger = get_debugpy_python_path(),
  timeout = 60000, -- 60 seconds timeout for this specific configuration
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Pytest: With Expression",
  module = "pytest",
  args = function()
    local expression = vim.fn.input("Test expression (-k): ")

    local args = {}

    -- If root dir is specified, add it as the first argument
    local root_dir = get_pytest_root_dir()
    if root_dir then
      table.insert(args, root_dir)
      vim.notify("Using pytest root dir: " .. root_dir, vim.log.levels.INFO)
    end

    -- Add the standard pytest options after the root dir
    table.insert(args, "-s") -- Allow print statements and interactive prompts
    table.insert(args, "-vvv") -- Very verbose output
    table.insert(args, "--no-header") -- Reduce header noise
    table.insert(args, "--no-summary") -- Reduce summary noise
    table.insert(args, "--capture=no") -- Don't capture stdout (allows interactive input)

    -- Add the expression filter
    table.insert(args, "-k")
    table.insert(args, expression)

    return args
  end,
  console = "integratedTerminal", -- This is crucial for interactive debugging
  pythonPath = get_project_python_path(),
  dap_python_debugger = get_debugpy_python_path(),
  timeout = 60000, -- 60 seconds timeout for this specific configuration
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Pytest: Current Test Function",
  module = "pytest",
  args = function()
    local test_name = get_current_test_name()
    if not test_name then
      -- Fallback to manual input if we couldn't detect the test name
      test_name = vim.fn.input("Test function name: ")
    end

    local root_dir = get_pytest_root_dir()
    local args = {
      "-s", -- Allow print statements and interactive prompts
      "-vvv", -- Very verbose output
      "--no-header", -- Reduce header noise
      "--no-summary", -- Reduce summary noise
      "--capture=no", -- Don't capture stdout (allows interactive input)
    }

    -- If root dir is specified, add it before the -k argument
    if root_dir then
      table.insert(args, root_dir)
    end

    -- Add the test expression
    table.insert(args, "-k")
    table.insert(args, test_name)

    -- Only add the file path if no root dir is specified
    if not root_dir then
      table.insert(args, vim.fn.expand("%:p")) -- Current file path
    end

    return args
  end,
  console = "integratedTerminal", -- This is crucial for interactive debugging
  pythonPath = get_project_python_path(),
  dap_python_debugger = get_debugpy_python_path(),
  timeout = 60000, -- 60 seconds timeout for this specific configuration
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Flask",
  module = "flask",
  args = function()
    local args = {
      "run",
      "-p",
      "8080",
      "--reload",
    }
    return args
  end,
  jinja = true,
  console = "integratedTerminal", -- This is crucial for interactive debugging
  pythonPath = get_project_python_path(),
  dap_python_debugger = get_debugpy_python_path(),
  timeout = 60000, -- 60 seconds timeout for this specific configuration
})

-- table.insert(dap.configurations.python, {
--   type = "python",
--   request = "launch",
--   name = "Flask",
--   module = "flask",
--   args = {
--     "run",
--     "--no-debugger",
--     "--no-reload",
--   },
--   env = {
--     FLASK_APP = "${file}",
--     FLASK_ENV = "development",
--   },
--   jinja = true,
-- })

-- table.insert(dap.configurations.python, {
--   type = "python",
--   request = "launch",
--   name = "Django",
--   program = "${workspaceFolder}/manage.py",
--   args = {
--     "runserver",
--     "--noreload",
--   },
--   django = true,
-- })

-- table.insert(dap.configurations.python, {
--   type = "python",
--   request = "launch",
--   name = "FastAPI",
--   module = "uvicorn",
--   args = {
--     "main:app",
--     "--reload",
--   },
--   pythonPath = function()
--     -- Get the Python path from the active virtual environment
--     local venv = os.getenv("VIRTUAL_ENV")
--     if venv then
--       return venv .. "/bin/python"
--     else
--       return vim.fn.exepath("python")
--     end
--   end,
-- })

-- EVENT LISTENERS

dap.listeners.before.launch["debug_info"] = function(session, body)
  vim.notify("DAP Launch - Session: " .. vim.inspect(session.config.name), vim.log.levels.INFO)
end

dap.listeners.before.attach["debug_info"] = function(session, body)
  vim.notify("DAP Attach - Session: " .. vim.inspect(session.config.name), vim.log.levels.INFO)
end

dap.listeners.before.event_terminated["debug_info"] = function(session, body)
  vim.notify("DAP Terminated - Session: " .. vim.inspect(session.config.name), vim.log.levels.INFO)
end

dap.listeners.before.event_exited["debug_info"] = function(session, body)
  vim.notify("DAP Exited - Session: " .. vim.inspect(session.config.name), vim.log.levels.INFO)
end

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end

-- dap-view setup
dap.listeners.before.attach["dap-view-config"] = function()
  dapview.open()
end

dap.listeners.before.launch["dap-view-config"] = function()
  dapview.open()
end

-- Helper function to save dap-view terminal contents
local function save_dap_terminal_contents(event_name)
  vim.notify("DEBUG: save_dap_terminal_contents called with event: " .. event_name, vim.log.levels.INFO)

  local success, result = pcall(function()
    -- Find the dap-view terminal buffer by name pattern
    local buffers = vim.api.nvim_list_bufs()
    local terminal_buf = nil
    local buffer_count = 0
    local dap_view_buffers = {}

    vim.notify("DEBUG: Checking " .. #buffers .. " buffers", vim.log.levels.INFO)

    for _, buf in ipairs(buffers) do
      if vim.api.nvim_buf_is_valid(buf) then
        buffer_count = buffer_count + 1
        local buf_filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        local buf_name = vim.api.nvim_buf_get_name(buf)

        vim.notify(
          "DEBUG: Buffer " .. buf .. " - filetype: '" .. buf_filetype .. "', name: '" .. buf_name .. "'",
          vim.log.levels.INFO
        )

        if buf_filetype == "dap-view-term" then
          terminal_buf = buf
          vim.notify(
            "Found dap-view terminal buffer (filetype: " .. buf_filetype .. "): " .. buf_name,
            vim.log.levels.INFO
          )
          break
        elseif buf_name:match("^term:") then
          -- Fallback to term: pattern if no dap-view-term found
          if not terminal_buf then
            terminal_buf = buf
            vim.notify("Found fallback terminal buffer (name starts with 'term:'): " .. buf_name, vim.log.levels.INFO)
          end
        elseif buf_name:match("dap") or buf_filetype:match("dap") then
          table.insert(dap_view_buffers, "Buffer " .. buf .. ": " .. buf_filetype .. " - " .. buf_name)
        end
      end
    end

    vim.notify("DEBUG: Total valid buffers: " .. buffer_count, vim.log.levels.INFO)
    if #dap_view_buffers > 0 then
      vim.notify("DEBUG: DAP-related buffers found: " .. table.concat(dap_view_buffers, "; "), vim.log.levels.INFO)
    end

    if terminal_buf then
      -- Get all lines from the terminal buffer
      local lines = vim.api.nvim_buf_get_lines(terminal_buf, 0, -1, false)
      local content = table.concat(lines, "\n")

      vim.notify("DEBUG: Terminal buffer has " .. #lines .. " lines", vim.log.levels.INFO)

      -- Write to /tmp/copied.txt
      local file = io.open("/tmp/copied.txt", "w")
      if file then
        file:write(content)
        file:close()
        vim.notify("Terminal contents saved to /tmp/copied.txt (" .. event_name .. ")", vim.log.levels.INFO)
      else
        vim.notify("Failed to write terminal contents to /tmp/copied.txt", vim.log.levels.ERROR)
      end
    else
      vim.notify("No terminal buffer found (" .. event_name .. ")", vim.log.levels.WARN)
    end
  end)

  if not success then
    vim.notify("Error saving terminal contents (" .. event_name .. "): " .. tostring(result), vim.log.levels.ERROR)
  end
end

-- Save dap-view terminal contents when debugging session ends (only use the first event)
dap.listeners.before.event_exited["save_terminal_contents"] = function()
  vim.notify("DEBUG: before.event_exited triggered - about to save terminal contents", vim.log.levels.INFO)
  save_dap_terminal_contents("on exit")
end

-- TODO: when dap terminates, I want to save the terminal window (dap-view-term) contents -- into /tmp/copied.txt, using a dap event listener.

-- dap.listeners.before.event_terminated["dap-view-config"] = function()
--   dapview.close()
-- end
--
-- dap.listeners.before.event_exited["dap-view-config"] = function()
--   dapview.close()
-- end

-- _G.run_pytest_on_current_file = function() -- on key-mappings-conf
--   local dap = require("dap")
--
--   vim.notify("Running pytest on current file", vim.log.levels.INFO)
--
--   local file_path = vim.fn.expand("%:p")
--
--   -- Get pytest from the active virtualenv
--   local venv = os.getenv("VIRTUAL_ENV")
--   local pytest_path
--   if venv then
--     pytest_path = venv .. "/bin/pytest"
--     vim.notify("Using pytest from active virtualenv: " .. pytest_path, vim.log.levels.INFO)
--   else
--     pytest_path = vim.fn.exepath("pytest")
--     vim.notify("No active virtualenv found, using system pytest: " .. pytest_path, vim.log.levels.INFO)
--   end
--
--   local config = {
--     type = "python",
--     request = "launch",
--     name = "Pytest Direct",
--     program = pytest_path,
--     args = {
--       "-s",
--       "-vvv",
--       file_path,
--     },
--     -- Use neovim venv for debugpy
--     pythonPath = vim.fn.expand("~/.pyenv/versions/neovim/bin/python"),
--   }
--
--   -- Write the configuration to a file
--   local config_file = io.open("/tmp/pytest_config.txt", "w")
--   if config_file then
--     config_file:write("Pytest config:\n")
--     config_file:write(vim.inspect(config))
--     config_file:close()
--     vim.notify("Pytest config written to /tmp/pytest_config.txt", vim.log.levels.INFO)
--   end
--
--   -- Try to run with this configuration
--   local status, err = pcall(function()
--     dap.run(config)
--   end)
--
--   if not status then
--     -- Write the error to a file
--     local error_file = io.open("/tmp/pytest_error.txt", "w")
--     if error_file then
--       error_file:write("Error running pytest: " .. tostring(err))
--       error_file:close()
--       vim.notify("Error details written to /tmp/pytest_error.txt", vim.log.levels.ERROR)
--     else
--       vim.notify("Failed to write error details to file", vim.log.levels.ERROR)
--     end
--   end
-- end

-- EXPORTED FUNCTIONS

function M.finish_debugging_and_close_windows()
  -- Terminate any active debug session, then close the UI
  dap.terminate()
  -- dapui.close()
  dapview.close()
  vim.notify("Debugging terminated and windows closed", vim.log.levels.INFO)
end

function M.run_config_by_name(config_name)
  -- Exposes all dap configurations on this file so they can be mapped on which-key
  for _, config in ipairs(dap.configurations.python) do
    if config.name == config_name then
      dap.run(config)
      return
    end
  end
  vim.notify("Configuration '" .. config_name .. "' not found", vim.log.levels.ERROR)
end

return M
