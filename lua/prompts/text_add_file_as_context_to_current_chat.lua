-- I want to create a slash command with codecompanion.nvim to be able to select a file from a specific path (path must be entered prior to open telescope to select the files).
-- The contents of the files I select with telescope will then be available as context for my future prompts.
-- I have an example of a custom prompt I created here on text_create_flashcards.lua.
-- The documention mentions that I need to create a new prompt and configure it as a slash commands here: https://codecompanion.olimorris.dev/extending/prompts.html .
-- Can you help me to implement this on this file?

local telescope = require("telescope.builtin")
local system = require("prompts.system")

-- Function to recursively list all files under path, excluding directories
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

return {
  strategy = "chat",
  description = "Add file as context to the current chat",
  opts = {
    short_name = "file-add-to-context",
    auto_submit = true,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = system.SYSTEM_PROMPT,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = function()
        local path = vim.fn.input("Enter directory path: ", "~/.local/share/nvim/code-companion-chat-history/")
        if not path or path == "" then
          return "Operation cancelled."
        end

        -- Ensure the path ends with a slash
        if path:sub(-1) ~= "/" then
          path = path .. "/"
        end

        path = vim.fn.expand(path)
        if vim.fn.isdirectory(path) ~= 1 then
          vim.notify("Invalid directory path: " .. path, vim.log.levels.ERROR)
          return "Invalid directory path: " .. path
        end

        -- Use telescope to select files
        local dir_name = path
        local prompt_title = "Select file to add to chat"

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

        local telescope_selected_file_path = ""

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
              local function get_selected_file_path()
                local selection = require("telescope.actions.state").get_selected_entry()
                local full_file_path = display_to_path[selection.value] -- Get the full path for the selected file

                vim.notify("selection full file path: " .. full_file_path)

                require("telescope.actions").close(prompt_bufnr)

                if vim.fn.filereadable(full_file_path) == 1 then
                  telescope_selected_file_path = vim.fn.fnameescape(full_file_path)
                  vim.notify("telescope_selected_file_path: " .. telescope_selected_file_path)
                else
                  vim.notify("File does not exist: " .. full_file_path) -- Handle case when file doesn't exist
                end
              end
              map("i", "<CR>", get_selected_file_path) -- Get path on Enter
              map("n", "<CR>", get_selected_file_path) -- Get path on Enter in normal mode too
              return true
            end,
          })
          :find()

        if telescope_selected_file_path == "" then
          vim.notify("No file was selected.")
          return
        end

        -- Build context message with file contents
        local context_message = "I'm adding the following file as context for our conversation:\n\n"

        local file = io.open(telescope_selected_file_path, "r")
        if file then
          local content = file:read("*all")
          file:close()

          local relative_path = telescope_selected_file_path:gsub("^" .. vim.fn.getcwd() .. "/", "")
          context_message = context_message .. "File: " .. relative_path .. "\n```\n" .. content .. "\n```\n\n"
        end

        context_message = context_message
          .. "Please acknowledge that you've received these files and will use them as context for our future conversation."

        vim.notify("Context message was set: " .. context_message)

        return context_message
      end,
    },
  },
}
