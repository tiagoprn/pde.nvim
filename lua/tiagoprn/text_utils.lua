local M = {} -- Creates a new table to isolate from the global scope
-- lua/tiagoprn/text_utils.lua

-- Function to notify the user
function M.notify_user(message, is_error)
  local level = is_error and vim.log.levels.ERROR or vim.log.levels.INFO
  vim.notify(message, level, { title = "Text Utils" })
end

-- Function to get a preview of the text (first `max_length` characters)
function M.get_preview(text, max_length)
  if #text <= max_length then
    return text
  else
    return string.sub(text, 1, max_length) .. "..."
  end
end

-- Function to handle existing file by renaming it with a date suffix
function M.handle_existing_file(file_path)
  local stat = vim.loop.fs_stat(file_path)
  if stat then
    -- Get the modification time of the existing file
    local mtime = stat.mtime
    local formatted_time = os.date("%Y%m%d-%H%M%S", mtime.sec)

    -- Split the file path into directory, name, and extension
    local dirname, basename = file_path:match("(.*/)(.*)")
    local name, ext = basename:match("(.+)(%..+)")

    if not name then
      -- If there's no extension, handle accordingly
      name = basename
      ext = ""
    end

    -- Construct the new file path with the date suffix
    local new_path = string.format("%s%s.%s%s", dirname, name, formatted_time, ext)

    -- Attempt to rename the existing file
    local ok, err = os.rename(file_path, new_path)
    if not ok then
      M.notify_user("Failed to rename existing file: " .. err, true)
      return false
    else
      M.notify_user("Existing file renamed to: " .. new_path, false)
    end
  end
  return true
end

-- Function to write text to a specified file
function M.write_to_file(file_path, text)
  local file, err = io.open(file_path, "w")
  if not file then
    M.notify_user("Failed to open file: " .. err, true)
    return false
  end

  -- Attempt to write the text to the file
  local success, write_err = file:write(text)
  if not success then
    M.notify_user("Failed to write to file: " .. write_err, true)
    file:close()
    return false
  end

  file:close()
  return true
end

function M.copy_visual_selection_to_file()
  -- Check if there is an active visual selection
  local mode = vim.fn.mode()
  if not mode:match("[vV\x16]") then
    M.notify_user("No visual selection detected.", true)
    return
  end

  -- Yank the visual selection into a temporary register
  vim.cmd('normal! "vy')

  -- Get the yanked selection from the temporary register
  local text = vim.fn.getreg("v")

  -- If the text is empty, notify the user
  if text == "" then
    M.notify_user("Visual selection is empty.", true)
    return
  end

  local file_path = "/tmp/copied.txt"

  -- Handle existing file by renaming if necessary
  if not M.handle_existing_file(file_path) then
    return
  end

  -- Attempt to write the selected text to the file
  if M.write_to_file(file_path, text) then
    -- Get a preview of the copied text
    local preview = M.get_preview(text, 15)
    M.notify_user(string.format('Selection saved to %s: "%s"', file_path, preview), false)
  else
    M.notify_user("Failed to save selection to file.", true)
  end
end

return M
