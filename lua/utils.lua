local M = {}

--- Writes a message to a log file in $HOME/.cache/nvim
--- @param message string The message to log
--- @param filename string|nil Optional filename. Defaults to "default.log"
function M.write_log(message, filename)
  filename = filename or "default.log"
  local log_dir = vim.fn.expand("$HOME/.cache/nvim")
  local log_path = log_dir .. "/" .. filename

  -- Silently create the directory if it does not exist
  if vim.fn.isdirectory(log_dir) == 0 then
    vim.fn.mkdir(log_dir, "p")
  end

  -- Construct the log entry with timestamp, CWD, and PID
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local cwd = vim.fn.getcwd()
  local pid = vim.fn.getpid()
  local log_entry = string.format("%s %s PID %d > %s", timestamp, cwd, pid, message)

  -- Open the file in append mode
  local f = io.open(log_path, "a")
  if f then
    f:write(log_entry .. "\n")
    f:close()
  end
end

return M
