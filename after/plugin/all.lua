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
	end,
})
