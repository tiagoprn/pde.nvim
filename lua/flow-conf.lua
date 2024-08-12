-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, flow = pcall(require, "flow")
if not status_ok then
	return
end

flow.setup({
	output = {
		buffer = true, -- floating buffer
		-- size = auto, -- possible values: "auto" (default) OR 1-100 (percentage of screen to cover)
		focused = false,
		modifiable = true,
		split_cmd = "split", -- can also be vsplit

		-- window_override = {
		--   border = 'double',
		--   title = 'Output',
		--   title_pos = 'center',
		--   style = 'minimal',
		--   ...
		-- }
	},
	custom_cmd_dir = "/storage/src/pde.nvim/flow-commands",

	-- OPTIONAL CUSTOM VARIABLES
	require("flow.vars").add_vars({
		str = "A FIXED STRING VARIABLE",
		var_with_func = function()
			-- the value of this var is computed by running this function at runtime
			return "A VARIABLE CALCULATED FROM A LUA FUNCTION"
		end,
	}),
})
