local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values

local M = {}

-- find_files: git_log on selected file

local function run_git_log_on_selection(prompt_bufnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		vim.cmd([[!git log ]] .. selection[1])
	end)
	return true
end

M.git_log = function()
	-- example for running a command on a file
	local opts = {
		attach_mappings = run_git_log_on_selection,
	}
	require("telescope.builtin").find_files(opts)
end

-- buffers: switch to buffer using :drop

local function run_drop_on_selection(prompt_bufnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		-- print(vim.inspect(selection))
		local selected_file = selection["filename"]
		local vim_command = ":drop " .. selected_file
		vim.cmd(vim_command)
		vim.notify("Switched to window with buffer -> " .. vim_command)
	end)
	return true
end

M.switch_to_buffer = function()
	-- example for running a command on a file
	local opts = {
		show_all_buffers = false,
		ignore_current_buffer = true,
		attach_mappings = run_drop_on_selection,
	}
	require("telescope.builtin").buffers(opts)
end

local function load_buffer_without_window_action(prompt_bufnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		-- print(vim.inspect(selection))

		local selected_file = selection["filename"]

		local bufnr = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_name(bufnr, selected_file)
		vim.api.nvim_buf_call(bufnr, vim.cmd.edit)

		vim.notify("Opened buffer '" .. selected_file .. "' without a window.")
	end)
	return true
end

M.load_buffer_without_window = function()
	-- example for running a command on a file
	local opts = {
		prompt_title = "Open file/buffer without opening a window",
		attach_mappings = load_buffer_without_window_action,
	}
	require("telescope.builtin").find_files(opts)
end

M.search_on_open_files = function()
	-- example for running a command on a file
	local opts = {
		prompt_title = "Search on open files",
		grep_open_files = true,
	}
	require("telescope.builtin").live_grep(opts)
end

local function find_project_root()
	local current_dir = vim.fn.expand("%:p:h") -- get directory of the current file
	while current_dir ~= "/" do -- loop until root
		if
			vim.fn.filereadable(current_dir .. "/requirements.txt") == 1
			or vim.fn.filereadable(current_dir .. "/pyproject.toml") == 1
		then
			return current_dir
		end
		current_dir = vim.fn.fnamemodify(current_dir, ":h") -- get parent directory
	end
	return nil -- return nil if project root wasn't found
end

M.generate_python_project_definitions_file = function()
	-- runs the python script that generates the 'definitions.txt' file used by python_project_search function below
	local project_root = find_project_root()
	if not project_root then
		vim.notify("Couldn't find the project root with requirements.txt or pyproject.toml!", vim.log.levels.ERROR)
		return
	end

	vim.notify("Generating definitions.txt file at the project_root...")
	local python_project_analyzer_script_path = vim.fn.expand("~/.config/nvim/python/python-project-analyzer.py")

	local command = "!" .. python_project_analyzer_script_path .. " " .. project_root
	vim.cmd(command)
	vim.notify("definitions.txt file successfully generated!")
end

M.python_project_search = function()
	local project_root = find_project_root()
	if not project_root then
		vim.notify("Couldn't find the project root with requirements.txt or pyproject.toml!", vim.log.levels.ERROR)
		return
	end

	-- The "definitions.txt" file below must be at the project root, and can be generated
	-- with the script "python-project-analyzer.py" that is on this repository.
	local definitions_file = project_root .. "/definitions.txt"
	if vim.fn.filereadable(definitions_file) ~= 1 then
		vim.notify("definitions.txt not found in the project root!", vim.log.levels.ERROR)
		return
	end

	-- Read and process the file content
	local lines = {}
	for line in io.lines(definitions_file) do
		local parts = {}
		for part in line:gmatch("%S+") do
			table.insert(parts, part)
		end

		if #parts >= 4 then
			local function_class_or_method = parts[1]
			local name = parts[2]
			local file = parts[3]
			local lnum = tonumber(parts[4])

			table.insert(lines, {
				display = function_class_or_method .. " " .. name,
				value = line,
				file = file,
				lnum = lnum,
			})
		end
	end

	-- Use telescope to search
	pickers
		.new({}, {
			prompt_title = "Python Project Search",
			finder = finders.new_table({
				results = lines,
				entry_maker = function(entry)
					return {
						value = entry.value,
						display = entry.display,
						ordinal = entry.display,
						path = entry.file,
						lnum = entry.lnum,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = previewers.new_buffer_previewer({
				define_preview = function(self, entry, status)
					if not entry or not entry.path or not entry.lnum then
						vim.notify("Invalid entry data", vim.log.levels.ERROR)
						return
					end

					-- Ensure the file exists
					local f = io.open(entry.path, "r")
					if not f then
						vim.notify("File not found: " .. entry.path, vim.log.levels.ERROR)
						return
					end

					-- Read specific lines from the file
					--    On the preview, we show only the line that corresponds to the
					--    class/method/function and the next 80 lines below it.
					local preview_lines = {}
					local line_count = 0
					for line in f:lines() do
						line_count = line_count + 1
						if line_count >= entry.lnum and line_count < entry.lnum + 80 then
							table.insert(preview_lines, line)
						elseif line_count >= entry.lnum + 80 then
							break
						end
					end
					f:close()

					-- Set up the preview window and buffer
					local bufnr = self.state.bufnr
					if not vim.api.nvim_buf_is_valid(bufnr) then
						bufnr = vim.api.nvim_create_buf(false, true)
						self.state.bufnr = bufnr
					end

					-- Load the specific lines into the buffer
					vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, preview_lines)
					vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

					-- Find the window associated with the buffer and set the cursor to the first line
					local preview_win = vim.fn.win_findbuf(bufnr)[1]
					if preview_win then
						vim.api.nvim_win_set_cursor(preview_win, { 1, 0 })
					end
				end,
			}),
		})
		:find()
end

return M
