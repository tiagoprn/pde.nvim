-- This allows nvim to not crash if this plugin is not installed.
local status_ok, neo_tree = pcall(require, "neo-tree")
if not status_ok then
  return
end

-- neo-tree setup: provides filesystem navigation & markdown TOC functionality
local M = {}

-- Helper function to extract header text and level from a treesitter node
local function parse_header_node(node, bufnr)
  -- Get the node text properly
  local header_text = vim.treesitter.get_node_text(node, bufnr)
  local level = 0

  -- Count the number of '#' characters to determine header level
  for char in header_text:gmatch("#") do
    level = level + 1
  end

  -- Extract the actual header text (everything after the '#' symbols and spaces)
  local text = header_text:match("^#+%s*(.*)$") or header_text

  -- Get the line number using the node's range method
  local start_row, _, _, _ = node:range()

  return {
    text = text,
    level = level,
    line = start_row + 1, -- treesitter is 0-indexed, vim lines are 1-indexed
  }
end

-- Function to get all markdown headers from current buffer using treesitter
local function get_markdown_headers()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

  if filetype ~= "markdown" then
    vim.notify("Not a markdown file", vim.log.levels.WARN)
    return {}
  end

  -- Get treesitter parser for markdown
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok or not parser then
    vim.notify("Treesitter markdown parser not available", vim.log.levels.WARN)
    return {}
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  local headers = {}

  -- Query for markdown headers (atx_heading nodes)
  local ok_query, query = pcall(
    vim.treesitter.query.parse,
    "markdown",
    [[
    (atx_heading) @header
  ]]
  )

  if not ok_query then
    vim.notify("Failed to create treesitter query", vim.log.levels.WARN)
    return {}
  end

  -- Use iter_captures instead of iter_matches for more reliable node access
  for id, node, metadata in query:iter_captures(root, bufnr) do
    if query.captures[id] == "header" then
      local header_info = parse_header_node(node, bufnr)
      table.insert(headers, header_info)
    end
  end

  return headers
end

-- Function to show TOC in a floating window with navigation
local function show_markdown_toc()
  -- FUTURE ENHANCEMENTS IDEAS:
  -- TODO: Different icons for different header levels
  -- TODO: Filtering by header level
  -- TODO: Auto-refresh when the markdown file changes

  local headers = get_markdown_headers()

  if #headers == 0 then
    vim.notify("No headers found in current markdown file", vim.log.levels.INFO)
    return
  end

  -- Create display lines for the floating window
  local lines = {}
  local header_map = {} -- Maps line number to header info

  table.insert(lines, "📋 Table of Contents")
  table.insert(lines, "==================")
  table.insert(lines, "")

  for i, header in ipairs(headers) do
    -- Create indentation based on header level
    local indent = string.rep("  ", math.max(0, header.level - 1))
    local icon = string.rep("●", header.level)
    local line = string.format("%s%s %s", indent, icon, header.text)

    table.insert(lines, line)
    header_map[#lines] = header -- Map display line to header info
  end

  -- Create floating window
  local width = 60
  local height = math.min(#lines + 2, 20)
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Make buffer read-only
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown-toc")

  -- Calculate window position (centered)
  local ui = vim.api.nvim_list_uis()[1]
  local win_width = ui.width
  local win_height = ui.height
  local col = math.floor((win_width - width) / 2)
  local row = math.floor((win_height - height) / 2)

  -- Window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Markdown TOC ",
    title_pos = "center",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window highlighting
  vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")

  -- Add syntax highlighting
  vim.api.nvim_buf_call(buf, function()
    vim.cmd([[
      syntax match TocTitle /^📋.*$/
      syntax match TocSeparator /^=\+$/
      syntax match TocLevel1 /^●[^●]*$/
      syntax match TocLevel2 /^  ●●[^●]*$/
      syntax match TocLevel3 /^    ●●●.*$/

      highlight link TocTitle Title
      highlight link TocSeparator Comment
      highlight link TocLevel1 Directory
      highlight link TocLevel2 String
      highlight link TocLevel3 Comment
    ]])
  end)

  -- Set keybindings for navigation
  local function goto_header()
    local current_line = vim.api.nvim_win_get_cursor(win)[1]
    local header = header_map[current_line]

    if header then
      -- Close the TOC window
      vim.api.nvim_win_close(win, true)

      -- Jump to the header line in the original buffer
      vim.api.nvim_win_set_cursor(0, { header.line, 0 })
      vim.cmd("normal! zz") -- Center the line

      vim.notify(string.format("Jumped to: %s", header.text), vim.log.levels.INFO)
    end
  end

  -- Keybindings
  local keymap_opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "<CR>", goto_header, keymap_opts)
  vim.keymap.set("n", "<2-LeftMouse>", goto_header, keymap_opts)
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, keymap_opts)
  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, keymap_opts)

  -- Position cursor on first header
  vim.api.nvim_win_set_cursor(win, { 4, 0 })
end

-- Create user command
vim.api.nvim_create_user_command("MarkdownTOC", show_markdown_toc, {
  desc = "Show markdown table of contents",
})

-- Setup neo-tree normally
neo_tree.setup({
  sources = {
    "filesystem",
    "buffers",
    "git_status",
  },

  -- window = {
  --   mappings = {
  --     -- Add TOC mapping to neo-tree
  --     ["<leader>t"] = function()
  --       show_markdown_toc()
  --     end,
  --   },
  -- },
})

-- Global keybinding for TOC
vim.keymap.set("n", "<F7>", show_markdown_toc, {
  desc = "Show Markdown TOC",
  silent = true,
})

return M
