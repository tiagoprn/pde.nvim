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

  -- Open the file in append mode
  local f = io.open(log_path, "a")
  if f then
    f:write(message .. "\n")
    f:close()
  end
end

return M
