local toggle_redir = {}
local is_redir_active = false

local function create_tmp_dir()
	local dir = "/storage/src/pde.nvim/tmp"
	local exists = vim.fn.isdirectory(dir)
	if exists == 0 then
		os.execute("mkdir -p " .. dir)
	end
end

function toggle_redir.toggle()
	local timestamp = os.date("%Y%m%d%H%M%S")
	local filepath = string.format("/storage/src/pde.nvim/tmp/%s.txt", timestamp)
	if not is_redir_active then
		create_tmp_dir()
		vim.cmd("redir! > " .. filepath)
		is_redir_active = true
		print("toggled ON - started redirecting messages to " .. filepath)
	else
		vim.cmd("redir END")
		is_redir_active = false
		print("toggled OFF - stopped redirecting messages to" .. filepath)
	end
end

return toggle_redir
