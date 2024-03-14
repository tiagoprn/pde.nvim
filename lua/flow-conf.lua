-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, flow = pcall(require, "flow")
if not status_ok then
	return
end

flow.setup({
	output = {
		buffer = true,
		size = 80, -- possible values: "auto" (default) OR 1-100 (percentage of screen to cover)
		focused = true,
		modifiable = true,

		-- window_override = {
		--   border = 'double',
		--   title = 'Output',
		--   title_pos = 'center',
		--   style = 'minimal',
		--   ...
		-- }
	},
	custom_cmd_dir = "/storage/src/pde.nvim/flow-commands",
})

-- optional custom variables
-- require('flow.vars').add_vars({
--     str = "test-val-2",
--     num = 3,
--     bool = true,
--     var_with_func = function()
--         -- the value of this var is computed by running this function at runtime
--         return "test-val"
--     end
-- })
