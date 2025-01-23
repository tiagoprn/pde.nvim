-- --- EVENT HOOKS
--
local group = vim.api.nvim_create_augroup("eventhooks", { clear = true })

-- Before saving a file, deletes any trailing whitespace at the end of each line.
-- If no trailing whitespace is found no change occurs, and the e flag means no error is displayed.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
  group = group,
})

-- When opening a new buffer, if it has no filetype defaults to text
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "text"
    end
  end,
  group = group,
})

-- Return to last edit position when opening files (You want this!)
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 0 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
  group = group,
})

-- Expands on what vim considers as a markdown filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.md", "*.markdown", "*.mmd" },
  command = "set filetype=markdown",
  group = group,
})

-- disable auto-folding on markdown files
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*.md",
  command = "set nofoldenable",
  group = group,
})

-- Create new files from skeletons
local skeleton_files = {
  ["*.sh"] = "script.sh",
  ["*.py"] = "script.py",
  ["*.lua"] = "script.lua",
}

-- Create new files from skeletons
vim.api.nvim_create_autocmd({ "BufNewFile", "BufWritePre" }, {
  pattern = { "*.sh", "*.py", "*.lua" },
  callback = function()
    local filepath = vim.fn.expand("%")
    if vim.fn.getfsize(filepath) <= 0 then -- Only if file is empty
      local ext = vim.fn.fnamemodify(filepath, ":e")

      -- TODO: in the future I can improve this to add more dynamic type of
      -- templates (lua modules exporting public functions, python models,
      -- minimal flask app, minimal fastapi app, etc...)
      local skeleton = string.format("~/.config/nvim/skeletons/script.%s", ext)
      skeleton = vim.fn.expand(skeleton)
      if vim.fn.filereadable(skeleton) == 1 then
        vim.cmd("0r " .. skeleton)
      end
    end
  end,
  group = group,
})
