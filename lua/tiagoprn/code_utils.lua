local ts = vim.treesitter
local ts_utils = require("nvim-treesitter.ts_utils")

local helpers = require("tiagoprn.helpers")

local M = {}

function M.print_lsp_supported_requests()
	-- Get a list of all requests/capabilities that the current LSP server provides
	local clients = vim.lsp.get_active_clients()
	if clients and #clients > 0 then
		print("Available LSP clients:")
		for _, client in ipairs(clients) do
			print(" - " .. client.name)
		end
		print("")

		local lsp_client = clients[1]
		local capabilities = lsp_client.server_capabilities
		if capabilities then
			local supported_requests = {}
			for request, _ in pairs(capabilities) do
				table.insert(supported_requests, request)
			end

			if #supported_requests > 0 then
				table.sort(supported_requests)
				print("Supported Requests (LSP client: " .. lsp_client.name .. "):")
				for _, request in ipairs(supported_requests) do
					print(request)
				end
				return
			else
				print("No supported requests.")
				return
			end
		else
			print("No capabilities found for LSP client: " .. lsp_client.name)
			return
		end
	end

	print("No LSP server found.")
end

function M.get_current_function()
	-- FIXME: Not working for python pylsp
	local params = vim.lsp.util.make_position_params()
	-- local capability_name = "textDocument/documentSymbol"
	local capability_name = "documentSymbol"
	local result = vim.lsp.buf_request_sync(vim.api.nvim_get_current_buf(), capability_name, params)
	local symbols = result[1].result or {}
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	for _, symbol in ipairs(symbols) do
		if
			symbol.kind == 12
			and symbol.range.start.line <= current_line
			and symbol.range["end"].line >= current_line
		then
			return symbol.name
		end
	end
	return nil
end

function M.run_command_on_function_or_method()
	local cursor_function_or_method_name = M.get_current_function()
	vim.notify(cursor_function_or_method_name)

	-- TODO: after that, use vim.input to ask for the command to run.
	--       E.g. pytest -s -vvv -k <vim_input_typed>
end

return M
