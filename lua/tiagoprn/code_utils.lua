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
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local current_col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local function_name = nil

  -- Iterate backward from the current line until the beginning of the buffer
  for line = current_line, 1, -1 do
    local text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    local matches = { text:match("def%s+([%w_]+)%s*%(") }
    if #matches > 0 then
      function_name = matches[1]
      break
    end
  end

  if function_name then
    -- print("Function name: " .. function_name)
    return function_name
  else
    -- print("No function found at the current position")
    return ""
  end
end

local function run_command_on_function_or_method_at_tmux_scratchpad_session(bash_command, function_or_method_name)
  local tmux_session_name = helpers.tmux_create_or_switch_to_scratchpad_session()

  local command = string.gsub(bash_command, "%[m%]", function_or_method_name)

  local escaped_command = command -- helpers.escape_single_quotes(command)

  vim.fn.setreg("+", escaped_command)
  vim.notify("Command copied to system clipboard: " .. escaped_command)

  local exit_code, output = helpers.tmux_run_bash_command_on_scratchpad_session(tmux_session_name, escaped_command)

  if exit_code == 0 then
    vim.notify("Successfully executed command!")
  else
    vim.notify("Error executing command!")
  end
end

function M.run_interactive_command_on_current_function_or_method_at_tmux_scratchpad_session()
  local cursor_function_or_method_name = M.get_current_function()

  vim.fn.setreg("+", cursor_function_or_method_name)
  vim.notify("Current function name copied to system clipboard: " .. cursor_function_or_method_name)

  vim.ui.input({
    prompt = "Type a bash command to run on the scratchpad session \n(type [m] to use the current method name): ",
    -- "telescope" below is to force using dressing.nvim
    telescope = require("telescope.themes").get_cursor(),
  }, function(bash_command)
    if bash_command then
      run_command_on_function_or_method_at_tmux_scratchpad_session(bash_command, cursor_function_or_method_name)
    end
  end)
end

function M.run_pytest_on_current_function_or_method_at_tmux_scratchpad_session()
  local cursor_function_or_method_name = M.get_current_function()

  vim.fn.setreg("+", cursor_function_or_method_name)
  vim.notify("Current function name copied to system clipboard: " .. cursor_function_or_method_name)

  vim.ui.input({
    prompt = "Type path (leave blank for the default 'watson'): ",
    -- "telescope" below is to force using dressing.nvim
    telescope = require("telescope.themes").get_cursor(),
  }, function(path)
    if path == nil or string.len(path) == 0 then
      path = "watson"
    end

    local bash_command = "pytest " .. path .. " -s -vvv -k '[m]'"
    run_command_on_function_or_method_at_tmux_scratchpad_session(bash_command, cursor_function_or_method_name)
  end)
end

function M.select_python_class()
  -- Check if Telescope is available

  local telescope = require("telescope")
  if not telescope then
    print("Telescope is not installed")
    return
  end

  local classes = {}
  local current_buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

  for i, line in ipairs(lines) do
    if line:match("^class%s+") then
      -- Assuming class definitions are not indented and start with 'class '
      table.insert(classes, { line, i }) -- Line and line number
    end
  end

  -- Using Telescope to select from the list of classes
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Available Python Classes",
      finder = require("telescope.finders").new_table({
        results = classes,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry[1],
            ordinal = entry[1],
            lnum = entry[2],
          }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(_, map)
        map("i", "<CR>", function(bufnr)
          local selection = require("telescope.actions.state").get_selected_entry(bufnr)
          require("telescope.actions").close(bufnr)
          vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 }) -- Go to the class line
        end)
        return true
      end,
    })
    :find()
end

function M.open_git_changed_files_with_telescope()
  local telescope = require("telescope.builtin")

  -- Get the list of changed files
  local handle = io.popen("git status --porcelain")
  if not handle then
    print("Failed to get changed files.")
    return
  end

  local result = handle:read("*a")
  handle:close()

  -- Check if there are any changes
  if result == "" then
    print("No changed files.")
    return
  end

  -- Parse the output to get filenames
  local changed_files = {}
  for line in result:gmatch("[^\r\n]+") do
    local file_path = line:match("^..%s(.+)$")
    if file_path then
      table.insert(changed_files, file_path)
    end
  end

  -- Use Telescope to pick a file from the list of changed files
  telescope.find_files({
    prompt_title = "Changed Files",
    cwd = vim.loop.cwd(),
    find_command = { "echo", table.concat(changed_files, "\n") },
  })
end

function M.source_file()
  vim.notify("TODO: implement to source lua files")
end

return M
