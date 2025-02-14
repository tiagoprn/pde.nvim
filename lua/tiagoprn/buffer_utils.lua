local M = {} -- creates a new table here to isolate from the global scope

function M.copy_current_buffer_absolute_path()
  local current_file_path = vim.fn.expand("%:p")
  vim.fn.writefile({ current_file_path }, "/tmp/copied.txt")
end

function M.copy_current_buffer_name()
  -- copies only the buffer name, without the directory where it is located
  local buffer_name = vim.fn.expand("%:t")
  vim.fn.writefile({ buffer_name }, "/tmp/copied.txt")
end

function M.copy_current_buffer_relative_path()
  local relative_path = vim.fn.expand("%")
  vim.fn.writefile({ relative_path }, "/tmp/copied.txt")
end

function M.copy_current_buffer_absolute_path_with_position()
  local current_file_path = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")
  local path_with_position = current_file_path .. ":" .. line_number
  vim.fn.writefile({ path_with_position }, "/tmp/copied.txt")
end

function M.copy_current_buffer_name_with_position()
  local buffer_name = vim.fn.expand("%:t")
  local line_number = vim.fn.line(".")
  local name_with_position = buffer_name .. ":" .. line_number
  vim.fn.writefile({ name_with_position }, "/tmp/copied.txt")
end

function M.copy_current_buffer_relative_path_with_position()
  local relative_path = vim.fn.expand("%")
  local line_number = vim.fn.line(".")
  local path_with_position = relative_path .. ":" .. line_number
  vim.fn.writefile({ path_with_position }, "/tmp/copied.txt")
end

function M.copy_default_clipboard_register_to_file()
  local yank_text = vim.fn.getreg("+")

  -- If the register is empty, do nothing
  if yank_text == nil or yank_text == "" then
    return
  end

  local file_path = "/tmp/copied.txt"
  local file = io.open(file_path, "w")

  if file then
    file:write(yank_text)
    file:close()

    -- Check if inside tmux and send a notification
    if os.getenv("TMUX") then
      os.execute("tmux display-message 'Saved to /tmp/copied.txt!'")
    end
  else
    vim.notify("Failed to write to " .. file_path, vim.log.levels.ERROR)
  end
end

return M
