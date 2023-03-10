-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, noice = pcall(require, "noice")
if not status_ok then
	return
end

-- we can also create custom "routes", so to e.g. hide some messages or process them. More on that here:
-- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#hide-written-messages-1

noice.setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		command_palette = false, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = true, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
	},
	views = { -- check available options at https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua
		cmdline_popup = {
			position = {
				-- row = "100%",
				row = "50%",
				col = "50%",
			},
		},
		split = {
			relative = "editor",
			size = "20%",
		},
		mini = {
			relative = "editor",
			border = {
				style = "rounded",
				padding = { 0, 1 },
			},
			position = {
				row = 2,
				col = "100%",
				-- col = 0,
			},
		},
		notify = {
			merge = true,
		},
	},
})
