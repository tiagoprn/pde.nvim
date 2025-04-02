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

-- dap.set_log_level("TRACE") -- Set to 'TRACE' for maximum verbosity

vim.notify("DAP configuration loading", vim.log.levels.INFO)

-- CONFIGURATION

dap.adapters.python = {
  type = "executable",
  command = vim.fn.expand("~/.pyenv/versions/neovim/bin/python"),
  args = { "-m", "debugpy.adapter" },
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
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
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
dap_python.setup(vim.fn.expand("~/.pyenv/versions/neovim/bin/python"))
dap_python.test_runner = "pytest"

local function get_debugpy_python_path()
  local neovim_venv_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/python")
  vim.notify("Using debugpy from: " .. neovim_venv_path, vim.log.levels.INFO)
  return neovim_venv_path
end

-- DEBUGGING LOGS

local function verify_python_path()
  local python_path = get_debugpy_python_path()
  local cmd = python_path .. " --version 2>&1"
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  vim.notify("Python version check: " .. result, vim.log.levels.INFO)
end

local function check_debugpy_installation()
  local cmd = vim.fn.expand("~/.pyenv/versions/neovim/bin/python")
    .. " -c \"import debugpy; print('debugpy is installed')\" 2>&1"
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  if result:find("debugpy is installed") then
    vim.notify("debugpy is properly installed in the neovim virtualenv", vim.log.levels.INFO)
  else
    vim.notify("debugpy is NOT installed in the neovim virtualenv. Error: " .. result, vim.log.levels.ERROR)
    vim.notify("Install it with: ~/.pyenv/versions/neovim/bin/pip install debugpy", vim.log.levels.INFO)
  end
end

local function verify_dap_python_setup()
  local status, err = pcall(function()
    local dap_python = require("dap-python")
    vim.notify("DAP Python setup path: " .. vim.inspect(dap_python._path), vim.log.levels.INFO)
  end)

  if not status then
    vim.notify("Error checking DAP Python setup: " .. tostring(err), vim.log.levels.ERROR)
  end
end

local function check_debugpy_installation_detailed()
  local python_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/python")
  local cmd = python_path
    .. " -c \"import sys; import debugpy; print(f'debugpy version: {debugpy.__version__}'); print(f'debugpy path: {debugpy.__file__}'); print(f'Python path: {sys.executable}')\" 2>&1"
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  -- Write the output to a file
  local output_file = io.open("/tmp/debugpy_info.txt", "w")
  if output_file then
    output_file:write(result)
    output_file:close()
    vim.notify("Debugpy info written to /tmp/debugpy_info.txt", vim.log.levels.INFO)
  else
    vim.notify("Failed to write debugpy info to file", vim.log.levels.ERROR)
  end
end

check_debugpy_installation()

verify_python_path()

verify_dap_python_setup()

check_debugpy_installation_detailed()

-- DAP CONFIGURATIONS (PROFILES TO RUN DAP)

dap.configurations.python = dap.configurations.python or {}

-- table.insert(dap.configurations.python, {
--   name = "Debug Test",
--   type = "python",
--   request = "launch",
--   program = "${file}", -- Use a string instead of a function
--   pythonPath = get_debugpy_python_path,
-- })

table.insert(dap.configurations.python, {
  -- This configuration is the simplest one.
  -- It can be used to validate dap is working to work on an pre-existing python file.
  name = "Debug Sample File",
  type = "python",
  request = "launch",
  program = "/storage/src/pde.nvim/python/dap_test.py", -- Hardcoded file path
  pythonPath = vim.fn.expand("~/.pyenv/versions/neovim/bin/python"), -- use neovim venv for debugpy
})

table.insert(dap.configurations.python, {
  name = "Debug Test Simple",
  type = "python",
  request = "launch",
  program = vim.fn.expand("%:p"), -- Directly expand the current file path
  pythonPath = get_debugpy_python_path(), -- Call the function directly
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Pytest: Current File",
  program = function()
    -- Get pytest from the active virtualenv
    local venv = os.getenv("VIRTUAL_ENV")
    local pytest_path
    if venv then
      pytest_path = venv .. "/bin/pytest"
      vim.notify("Using pytest from active virtualenv: " .. pytest_path, vim.log.levels.INFO)
    else
      pytest_path = vim.fn.exepath("pytest")
      vim.notify("No active virtualenv found, using system pytest: " .. pytest_path, vim.log.levels.INFO)
    end
    return pytest_path
  end,
  args = function()
    local file_path = vim.fn.expand("%:p") -- Get absolute path of current file
    vim.notify("Running pytest on file: " .. file_path, vim.log.levels.INFO)
    return {
      "-s", -- Allow print statements to be displayed
      "-vvv", -- Very verbose output
      file_path, -- Use explicit file path
    }
  end,
  -- Use neovim venv for debugpy
  pythonPath = vim.fn.expand("~/.pyenv/versions/neovim/bin/python"),
})

-- table.insert(dap.configurations.python, {
--   name = "Debug Test Code",
--   type = "python",
--   request = "launch",
--   code = "import sys; print(f'Python version: {sys.version}'); print('Debug Test Code works!')",
--   pythonPath = get_debugpy_python_path(),
-- })

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

-- table.insert(dap.configurations.python, {
--   type = "python",
--   request = "launch",
--   name = "Pytest: With Expression",
--   module = "pytest",
--   args = function()
--     local expression = vim.fn.input("Test expression (-k): ")
--     return {
--       "-s",
--       "-vvv",
--       "-k",
--       expression,
--     }
--   end,
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
