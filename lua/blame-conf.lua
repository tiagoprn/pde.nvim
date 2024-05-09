-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, blame = pcall(require, "blame")
if not status_ok then
	return
end

blame.setup({
	date_format = "%Y-%m-%d %H:%M",
	merge_consecutive = false,
	max_summary_width = 30,
	colors = nil,
	commit_detail_view = "vsplit",
	mappings = {
		commit_info = "i",
		stack_push = "b", -- older change, default <TAB>
		stack_pop = "f", -- newer change, default <BS>
		show_commit = "<CR>",
		close = { "<esc>", "q" },
	},
})
