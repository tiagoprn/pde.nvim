-- this has the function "preview_and_open_file", that I can customize to
-- create custom pickers pointing to different directories.

local telescope = require("telescope.builtin")
local M = {}

-- Function to recursively list all files under the snippets path, excluding directories
local function get_all_files_in_dir(dir_name)
  -- dir_name e.g.: vim.fn.expand("~/.config/nvim/lua/snippets/")
  local dir_path = dir_name
  local file_paths = vim.fn.glob(dir_path .. "**/*", true, true) -- Recursively list all files and directories
  local files = {}

  -- Filter out directories
  for _, file_path in ipairs(file_paths) do
    if vim.fn.isdirectory(file_path) == 0 then -- Only include files (not directories)
      table.insert(files, file_path)
    end
  end

  return files
end

-- Function to preview and open selected file
function M.preview_and_open_file(dir_name, prompt_title)
  -- Ensure dir_name ends with a slash
  if dir_name:sub(-1) ~= "/" then
    dir_name = dir_name .. "/"
  end

  local file_paths = get_all_files_in_dir(dir_name)

  -- Create a mapping of display names to full paths
  local display_to_path = {}
  local display_names = {}

  for _, file_path in ipairs(file_paths) do
    local display_name = file_path:sub(#dir_name + 1)
    display_to_path[display_name] = file_path
    table.insert(display_names, display_name)
  end

  -- Display files in Telescope with exact matching in fuzzy search
  require("telescope.pickers")
    .new({}, {
      prompt_title = prompt_title,
      finder = require("telescope.finders").new_table({
        results = display_names,
      }),
      sorter = require("telescope.sorters").get_fuzzy_file({
        exact = true, -- Enable exact matching with fuzzy search
      }),
      previewer = require("telescope.previewers").new_buffer_previewer({
        define_preview = function(self, entry, status)
          -- Get the full file path using the display name
          local full_file_path = display_to_path[entry.value]
          local content = vim.fn.readfile(full_file_path) -- Read the file contents
          -- Display the content of the file in the preview window
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)

          -- Set the filetype for syntax highlighting in the preview window
          local filetype = vim.fn.fnamemodify(full_file_path, ":e") -- Get the file extension to determine filetype
          vim.bo[self.state.bufnr].filetype = filetype
        end,
      }),
      attach_mappings = function(prompt_bufnr, map)
        local function open_file()
          local selection = require("telescope.actions.state").get_selected_entry()
          local full_file_path = display_to_path[selection.value] -- Get the full path for the selected file

          require("telescope.actions").close(prompt_bufnr)

          if vim.fn.filereadable(full_file_path) == 1 then
            vim.cmd("tabnew " .. vim.fn.fnameescape(full_file_path)) -- Open the selected file on a new tab using the full path
          else
            print("File does not exist: " .. full_file_path) -- Handle case when file doesn't exist
          end
        end
        map("i", "<CR>", open_file) -- Open file on Enter
        map("n", "<CR>", open_file) -- Open file on Enter in normal mode too
        return true
      end,
    })
    :find()
end

return M
