local M = {} -- creates a new table here to isolate from the global scope

function M.searchWriteloop()
	require("telescope.builtin").live_grep({
		prompt_title = "\\ Search Writeloop Contents /",
		cwd = "/storage/src/writeloop-raw/",
	})
end

function M.searchFleetingNotes()
	require("telescope.builtin").live_grep({
		prompt_title = "\\ Search FleetingNote /",
		cwd = "/storage/docs/fleeting-notes/",
	})
end

function M.searchTaskCard()
	require("telescope.builtin").live_grep({
		prompt_title = "\\ Search Task Card /",
		cwd = "/storage/docs/tasks/",
	})
end

function M.openPersonalDoc()
	require("telescope.builtin").find_files({
		prompt_title = "\\ Find Personal Doc /",
		cwd = "/storage/docs/notes/",
	})
end

return M
