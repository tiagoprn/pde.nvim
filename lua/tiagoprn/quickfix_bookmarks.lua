local M = {}

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
      vim.notify("Bookmark already exists: " .. new_entry.filename .. ":" .. new_entry.lnum, vim.log.levels.WARN)
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
  vim.notify(
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

  -- Filter out the selected entry
  local new_qflist = vim.tbl_filter(function(item)
    return not (item.filename == selected_entry.filename and item.lnum == selected_entry.lnum)
  end, items)

  if #new_qflist < #items then
    -- Set quickfix list first (removes the item)
    vim.fn.setqflist(new_qflist, "r")

    -- If the list is empty, clear it properly to avoid stale data
    if #new_qflist == 0 then
      vim.fn.setqflist({}, "r") -- Clear the quickfix list
    end

    -- Then update quickfix list metadata
    vim.fn.setqflist({}, "r", { title = list_name })

    vim.notify("Bookmark removed: " .. selected_entry.filename .. ":" .. selected_entry.lnum, vim.log.levels.WARN)
  else
    vim.notify("Bookmark not found", vim.log.levels.WARN)
  end
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.delete_quickfix_item_with_telescope()
  require("telescope.builtin").quickfix({
    attach_mappings = function(_, map)
      local function delete_selected_bookmark(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          remove_bookmark_by_entry(selection)
          actions.close(prompt_bufnr)
        else
          vim.notify("No bookmark selected", vim.log.levels.WARN)
        end
      end

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
  vim.notify("Quickfix list saved as: " .. list_name, vim.log.levels.INFO)
end

return M
