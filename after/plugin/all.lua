-- Creates an autocommand that runs when Vim has finished entering
-- (which is a good point to assume that all plugins are loaded).
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Disable spell checking by default for all file types
    vim.opt.spell = false

    -- WinBar is using a differnt pattern of colors which is the same as the
    -- statusline, depending on the mode I am (normal, insert, replace, etc...)
    -- Tabs:
    --    inactive tabs: Tabline
    --    background: TabLineFill
    --    active tab: TabLineSel
    vim.cmd([[
      highlight TabLine guibg=#606060 guifg=#ffffff
      highlight TabLineFill guibg=#606060 guifg=#ffffff
      highlight TabLineSel guibg=#ff007b guifg=#ffffff
      highlight Comment guifg=#f5eea3
    ]])

    -- store the messages in Neovim's :messages history without showing a popup
    -- or printing anything to the command line.
    -- You can view these notifications later using the :messages command.
    vim.notify = function(msg, log_level, _opts)
      log_level = log_level or vim.log.levels.INFO
      -- Use vim.api.nvim_command to log the message without showing it immediately
      vim.cmd(string.format('echom "%s"', vim.fn.escape(msg, '"')))
    end
  end,
})
