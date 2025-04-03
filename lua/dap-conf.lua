-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, dap_python = pcall(require, "dap-python")
if not status_ok then
  return
end

local M = {}

local dap = require("dap")
local dapui = require("dapui")
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

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "console", size = 1.0 },
      },
      size = 0.2, -- 20% window height
      position = "bottom",
    },
    {
      elements = {
        { id = "repl", size = 1.0 },
      },
      size = 0.2, -- 20% window height
      position = "bottom",
    },
  },
})

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
    local file_path = vim.fn.expand("%:p") -- Get absolute path of current file
    vim.notify("Running pytest on file: " .. file_path, vim.log.levels.INFO)
    return {
      "-s", -- Allow print statements and interactive prompts
      "-vvv", -- Very verbose output
      "--no-header", -- Reduce header noise
      "--no-summary", -- Reduce summary noise
      "--capture=no", -- Don't capture stdout (allows interactive input)
      file_path, -- Use explicit file path
    }
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
    return {
      "-s", -- Allow print statements and interactive prompts
      "-vvv", -- Very verbose output
      "--no-header", -- Reduce header noise
      "--no-summary", -- Reduce summary noise
      "--capture=no", -- Don't capture stdout (allows interactive input)
      "-k",
      expression,
    }
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

    return {
      "-s", -- Allow print statements and interactive prompts
      "-vvv", -- Very verbose output
      "--no-header", -- Reduce header noise
      "--no-summary", -- Reduce summary noise
      "--capture=no", -- Don't capture stdout (allows interactive input)
      "-k",
      test_name,
      vim.fn.expand("%:p"), -- Current file path
    }
  end,
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

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

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
  dapui.close()
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
