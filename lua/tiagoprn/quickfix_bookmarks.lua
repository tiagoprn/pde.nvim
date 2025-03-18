local M = {}

-- Helper function to display messages in Neovim's message area
local function echo_msg(msg, level)
  local hl_group = "Normal"
  if level == vim.log.levels.ERROR then
    hl_group = "ErrorMsg"
  elseif level == vim.log.levels.WARN then
    hl_group = "WarningMsg"
  elseif level == vim.log.levels.INFO then
    hl_group = "Comment"
  end

  vim.api.nvim_echo({ { msg, hl_group } }, true, {})
end

function M.add_bookmark()
  -- Get current folder name
  local cwd = vim.fn.expand("%:p:h:t") -- Gets the directory name only
  local list_name = cwd .. "__bookmarks"

  -- Get existing quickfix list and ensure it has items
  local qflist = vim.fn.getqflist()
  local items = qflist or {}

  -- Check if quickfix list was empty before adding
  local was_empty = #items == 0

  -- Create new bookmark entry
  local new_entry = {
    filename = vim.fn.expand("%:p"), -- Absolute file path
    lnum = vim.fn.line("."),
    col = vim.fn.col("."),
    text = "Bookmark: " .. vim.fn.getline("."),
  }

  -- Prevent duplicate bookmarks
  for _, item in ipairs(items) do
    if item.filename == new_entry.filename and item.lnum == new_entry.lnum then
      echo_msg("Bookmark already exists: " .. new_entry.filename .. ":" .. new_entry.lnum, vim.log.levels.WARN)
      return
    end
  end

  -- Add the new entry at the beginning
  table.insert(items, 1, new_entry)

  -- Set quickfix list first (excluding title here)
  vim.fn.setqflist(items, "r")

  -- Then update quickfix list metadata separately
  vim.fn.setqflist({}, "r", { title = list_name })

  -- Open the quickfix list if it was previously empty
  if was_empty then
    vim.cmd("copen")
  end

  -- Notify user
  echo_msg(
    "Bookmark added to " .. list_name .. ": " .. new_entry.filename .. ":" .. new_entry.lnum,
    vim.log.levels.INFO
  )
end

local function remove_bookmark_by_entry(selected_entry)
  -- Get the current folder's bookmarks list
  local cwd = vim.fn.expand("%:p:h:t")
  local list_name = cwd .. "__bookmarks"

  -- Get the current quickfix list
  local qflist = vim.fn.getqflist()
  local items = qflist or {}

  -- Track if we found and removed the bookmark
  local found = false
  local new_qflist = {}

  for _, item in ipairs(items) do
    -- Get the actual filename from bufnr if needed
    local item_filename = item.filename
    if not item_filename or item_filename == "" then
      if item.bufnr and item.bufnr > 0 then
        item_filename = vim.api.nvim_buf_get_name(item.bufnr)
      end
    end

    -- Check if this is the item to remove
    if item_filename == selected_entry.filename and item.lnum == selected_entry.lnum then
      found = true
      -- Skip this item (don't add to new_qflist)
    else
      table.insert(new_qflist, item)
    end
  end

  if found then
    -- Set quickfix list first (removes the item)
    vim.fn.setqflist(new_qflist, "r")

    -- If the list is empty, clear it properly to avoid stale data
    if #new_qflist == 0 then
      vim.fn.setqflist({}, "r") -- Clear the quickfix list
    end

    -- Then update quickfix list metadata
    vim.fn.setqflist({}, "r", { title = list_name })

    echo_msg("Bookmark removed: " .. selected_entry.filename .. ":" .. selected_entry.lnum, vim.log.levels.WARN)
  else
    echo_msg("Bookmark not found. Please check if the file path matches exactly.", vim.log.levels.WARN)
  end
end

function M.delete_quickfix_item_with_telescope()
  -- Import these inside the function to ensure they're available
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  require("telescope.builtin").quickfix({
    prompt_title = "Bookmarks (dd or <C-d> to delete)",
    attach_mappings = function(prompt_bufnr, map)
      -- Simplified delete function
      local function delete_selected_bookmark(bufnr)
        local selection = action_state.get_selected_entry()

        if not selection then
          echo_msg("No bookmark selected", vim.log.levels.WARN)
          return
        end

        -- Convert Telescope selection to the format expected by remove_bookmark_by_entry
        local entry = {
          filename = selection.filename or selection.value.filename,
          lnum = selection.lnum or selection.value.lnum,
          col = selection.col or selection.value.col,
        }

        -- Simple confirmation using vim.fn.confirm
        local choice = vim.fn.confirm("Delete bookmark: " .. entry.filename .. ":" .. entry.lnum .. "?", "&Yes\n&No", 2)

        if choice == 1 then -- Yes
          remove_bookmark_by_entry(entry)
          -- Simply close the telescope window
          actions.close(bufnr)
        end
      end

      -- Add mappings
      map("i", "<C-d>", delete_selected_bookmark)
      map("n", "dd", delete_selected_bookmark)

      return true
    end,
  })
end

function M.set_current_quickfix_as_bookmarks()
  -- Get current folder name
  local cwd = vim.fn.expand("%:p:h:t")
  local list_name = cwd .. "__bookmarks"

  -- Get the current quickfix list
  local qflist = vim.fn.getqflist()

  -- Set it in a global variable
  vim.g["quickfix_" .. list_name] = qflist

  -- Notify user
  echo_msg("Quickfix list saved as: " .. list_name, vim.log.levels.INFO)
end

return M
