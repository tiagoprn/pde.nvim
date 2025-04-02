-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, dap_python = pcall(require, "dap-python")
if not status_ok then
  return
end

local dap = require("dap")
local dapui = require("dapui")
local dap_vt = require("nvim-dap-virtual-text")

-- Configure DAP UI with more detailed settings
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

-- Add configurations for Flask/Django/FastAPI
dap.configurations.python = dap.configurations.python or {}
table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Flask",
  module = "flask",
  args = {
    "run",
    "--no-debugger",
    "--no-reload",
  },
  env = {
    FLASK_APP = "${file}",
    FLASK_ENV = "development",
  },
  jinja = true,
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Django",
  program = "${workspaceFolder}/manage.py",
  args = {
    "runserver",
    "--noreload",
  },
  django = true,
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "FastAPI",
  module = "uvicorn",
  args = {
    "main:app",
    "--reload",
  },
  pythonPath = function()
    -- Get the Python path from the active virtual environment
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
      return venv .. "/bin/python"
    else
      return vim.fn.exepath("python")
    end
  end,
})

-- Automatically open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
