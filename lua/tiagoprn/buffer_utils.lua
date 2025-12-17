local M = {} -- creates a new table here to isolate from the global scope

function M.copy_current_buffer_absolute_path()
  local current_file_path = vim.fn.expand("%:p")
  vim.fn.writefile({ current_file_path }, "/tmp/clipboard/copied.txt")
end

function M.copy_current_buffer_name()
  -- copies only the buffer name, without the directory where it is located
  local buffer_name = vim.fn.expand("%:t")
  vim.fn.writefile({ buffer_name }, "/tmp/clipboard/copied.txt")
end

function M.copy_current_buffer_relative_path()
  local relative_path = vim.fn.expand("%")
  vim.fn.writefile({ relative_path }, "/tmp/clipboard/copied.txt")
end

function M.copy_current_buffer_absolute_path_with_position()
  local current_file_path = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")
  local path_with_position = current_file_path .. ":" .. line_number
  vim.fn.writefile({ path_with_position }, "/tmp/clipboard/copied.txt")
end

function M.copy_current_buffer_name_with_position()
  local buffer_name = vim.fn.expand("%:t")
  local line_number = vim.fn.line(".")
  local name_with_position = buffer_name .. ":" .. line_number
  vim.fn.writefile({ name_with_position }, "/tmp/clipboard/copied.txt")
end

function M.copy_current_buffer_relative_path_with_position()
  local relative_path = vim.fn.expand("%")
  local line_number = vim.fn.line(".")
  local path_with_position = relative_path .. ":" .. line_number
  vim.fn.writefile({ path_with_position }, "/tmp/clipboard/copied.txt")
end

function M.copy_default_clipboard_register_to_file()
  local yank_text = vim.fn.getreg("+")

  -- If the register is empty, do nothing
  if yank_text == nil or yank_text == "" then
    return
  end

  local file_path = "/tmp/clipboard/copied.txt"
  local file = io.open(file_path, "w")

  if file then
    file:write(yank_text)
    file:close()

    -- Check if inside tmux and send a notification
    if os.getenv("TMUX") then
      os.execute("tmux display-message 'Saved to /tmp/clipboard/copied.txt!'")
    end
  else
    vim.notify("Failed to write to " .. file_path, vim.log.levels.ERROR)
  end
end

function M.save_buffer_copy_to_tmp()
  -- Check if current window is quickfix
  local is_quickfix = vim.bo.buftype == "quickfix"

  if is_quickfix then
    -- Handle quickfix list saving
    return M.save_quickfix_to_tmp()
  end

  -- Check if current buffer is a noice buffer
  local is_noice = vim.bo.filetype == "noice" or string.match(vim.api.nvim_buf_get_name(0), "noice")

  if is_noice then
    -- Show message for noice buffers
    vim.notify(
      "noice (folke/noice.nvim) filetype is not supported. Try using nvim's standard quickfix.",
      vim.log.levels.WARN
    )
    return
  end

  -- Original function for regular buffers
  -- Get the buffer type or name
  local buffer_name = vim.fn.expand("%:t")
  local buffer_type = vim.bo.filetype

  -- Determine base name for the file
  local basename
  if buffer_name ~= "" then
    basename = vim.fn.expand("%:t:r")
  elseif buffer_type ~= "" then
    -- Clean buffer_type by removing spaces and non-alphanumeric characters
    basename = buffer_type:gsub("%s+", ""):gsub("[^%w]", "")
  else
    basename = "unnamed_buffer"
  end

  -- Clean the basename to remove any remaining spaces or special characters
  basename = basename:gsub("%s+", ""):gsub("[^%w]", "")

  -- Get extension if available
  local extension = vim.fn.expand("%:e")

  -- Generate timestamp in YYYY-MM-DD-HH-MM-SS format
  local timestamp = os.date("%Y-%m-%d-%H-%M-%S")

  -- Create the new filename with timestamp
  local new_filename = "/tmp/clipboard/" .. basename .. "." .. timestamp

  -- Add appropriate extension
  if buffer_name ~= "" and extension and extension ~= "" then
    -- Use original extension for named buffers
    new_filename = new_filename .. "." .. extension
  else
    -- Add .txt extension for unnamed buffers or those without extension
    new_filename = new_filename .. ".txt"
  end

  -- Use Vim's :w command to write the buffer to the new file
  local success, result = pcall(function()
    vim.cmd("silent write! " .. vim.fn.fnameescape(new_filename))
  end)

  if success then
    vim.notify("Buffer saved to: " .. new_filename, vim.log.levels.INFO)
  else
    vim.notify("Error saving buffer: " .. tostring(result), vim.log.levels.ERROR)
  end
end

function M.save_quickfix_to_tmp()
  -- Generate timestamp in YYYY-MM-DD-HH-MM-SS format
  local timestamp = os.date("%Y-%m-%d-%H-%M-%S")
  local new_filename = "/tmp/clipboard/quickfix." .. timestamp .. ".txt"

  -- Get quickfix items
  local qf_items = vim.fn.getqflist()

  -- Open file for writing
  local file, err = io.open(new_filename, "w")
  if not file then
    vim.notify("Error opening file: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  -- Write quickfix items to file
  for _, item in ipairs(qf_items) do
    local line = ""
    if item.bufnr > 0 then
      local filename = vim.fn.bufname(item.bufnr)
      if filename and filename ~= "" then
        line = filename .. ":"
      end
    end

    if item.lnum then
      line = line .. item.lnum
      if item.col then
        line = line .. ":" .. item.col
      end
      line = line .. ":"
    end

    if item.text then
      line = line .. " " .. item.text
    end

    file:write(line .. "\n")
  end

  file:close()
  vim.notify("Quickfix list saved to: " .. new_filename, vim.log.levels.INFO)
  return new_filename
end

function M.simple_zoom()
  -- -- based on: https://www.reddit.com/r/neovim/comments/1jk9vkn/my_tmuxlike_zoom_solution/?share_id=Fs2UvsKRqAZEzTgAZX-4d&utm_name=androidcss
  -- Creates a window-specific autocommand for the zoomed window.
  -- This implements behaviour to return to the original window when closing a zoomed window,
  -- but it applies only to the windows opened through the zoom command.
  local winid = vim.api.nvim_get_current_win()
  vim.cmd("tab split")
  local new_winid = vim.api.nvim_get_current_win()

  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(new_winid),
    once = true,
    callback = function()
      vim.api.nvim_set_current_win(winid)
    end,
  })
end

function M.close_unshown_buffers()
  -- closes all buffers that are not visible on windows

  vim.cmd("redraw") -- make sure window info is current

  local visible_bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    visible_bufs[buf] = true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not visible_bufs[buf] then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end

  vim.notify("Unshown buffers were closed.")
end

function M.copy_visual_selection_to_register_and_file()
  -- This function should be called from a visual mode mapping
  -- The function needs to be executed while still in visual mode

  -- Store the current register content to restore later
  local old_reg = vim.fn.getreg('"')
  local old_regtype = vim.fn.getregtype('"')

  -- Use Vim's native yank command to get the visual selection
  vim.api.nvim_feedkeys("y", "x", false)

  -- Small delay to ensure the yank completes
  vim.cmd("sleep 10m")

  -- Get the yanked text from the default register
  local selected_text = vim.fn.getreg('"')

  -- Restore the original register content
  vim.fn.setreg('"', old_reg, old_regtype)

  -- If no text was selected, notify and return
  if selected_text == nil or selected_text == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Copy to register "f"
  vim.fn.setreg("f", selected_text)

  -- Write to /tmp/clipboard/copied.txt
  local file_path = "/tmp/clipboard/copied.txt"
  local file = io.open(file_path, "w")

  if file then
    file:write(selected_text)
    file:close()

    -- Check if inside tmux and send a notification
    if os.getenv("TMUX") then
      os.execute("tmux display-message 'Selected text copied to vim register \"f\" and /tmp/clipboard/copied.txt'")
    else
      vim.notify('Selected text copied to vim register "f" and /tmp/clipboard/copied.txt', vim.log.levels.INFO)
    end
  else
    vim.notify("Failed to write to " .. file_path, vim.log.levels.ERROR)
  end
end

function M.copy_visual_selection_as_markdown()
  -- Store the current register content to restore later
  local old_reg = vim.fn.getreg('"')
  local old_regtype = vim.fn.getregtype('"')

  -- Use Vim's native yank command to get the visual selection
  vim.api.nvim_feedkeys("y", "x", false)

  -- Small delay to ensure the yank completes
  vim.cmd("sleep 10m")

  -- Get the yanked text from the default register
  local selected_text = vim.fn.getreg('"')

  -- Restore the original register content
  vim.fn.setreg('"', old_reg, old_regtype)

  -- If no text was selected, notify and return
  if selected_text == nil or selected_text == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Get the current buffer's filetype and relative path
  local filetype = vim.bo.filetype
  local relative_path = vim.fn.expand("%")

  -- Create markdown code block with filetype and path inside the block
  local markdown_text = "```" .. filetype .. "\n" .. "# " .. relative_path .. "\n" .. selected_text .. "\n```"

  -- Copy to register "m"
  vim.fn.setreg("m", markdown_text)

  -- Write to /tmp/clipboard/copied.txt
  local file_path = "/tmp/clipboard/copied.txt"
  local file = io.open(file_path, "w")

  if file then
    file:write(markdown_text)
    file:close()

    -- Check if inside tmux and send a notification
    if os.getenv("TMUX") then
      os.execute(
        "tmux display-message 'Selected text copied as markdown to vim register \"m\" and /tmp/clipboard/copied.txt'"
      )
    else
      vim.notify(
        'Selected text copied as markdown to vim register "m" and /tmp/clipboard/copied.txt',
        vim.log.levels.INFO
      )
    end
  else
    vim.notify("Failed to write to " .. file_path, vim.log.levels.ERROR)
  end
end

function M.delete_term_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match("^term") or name:find("dap%-terminal") then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
end

return M
