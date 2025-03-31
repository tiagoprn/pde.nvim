local telescope = require("telescope.builtin")
local M = {}

-- Function to recursively list all files under the snippets path, excluding directories
function M.get_all_files_in_snippets_dir()
  local snippets_dir = vim.fn.expand("~/.config/nvim/lua/snippets/")
  local file_paths = vim.fn.glob(snippets_dir .. "**/*", true, true) -- Recursively list all files and directories
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
function M.preview_and_open_snippet()
  local file_paths = M.get_all_files_in_snippets_dir()

  -- Display files in Telescope
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Snippets",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      sorter = require("telescope.sorters").get_fuzzy_file(),
      previewer = require("telescope.previewers").new_buffer_previewer({
        define_preview = function(self, entry, status)
          local file_path = entry[1]
          local content = vim.fn.readfile(file_path) -- Read the file contents
          -- Display the content of the file in the preview window
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
        end,
      }),
      attach_mappings = function(prompt_bufnr, map)
        local function open_file()
          local selection = require("telescope.actions.state").get_selected_entry()
          local file_path = selection[1]
          vim.cmd("edit " .. file_path) -- Open the selected file
        end
        map("i", "<CR>", open_file) -- Open file on Enter
        return true
      end,
    })
    :find()
end

return M
