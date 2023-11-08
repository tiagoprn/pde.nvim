local status_ok, auto_indent = pcall(require, "auto-indent")
if not status_ok then
	return
end

auto_indent.setup({
	lightmode = true,
	indentexpr = function(lnum)
		return require("nvim-treesitter.indent").get_indent(lnum)
	end,
	ignore_filetype = {},
})
