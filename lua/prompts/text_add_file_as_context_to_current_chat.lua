-- This creates a slash command with codecompanion.nvim to be able to select a file using telescope.
--
-- The contents of the file I select with telescope will then be stored on the "w" register so I can paste it on the chat window.
--
-- If the file is text or markdown, I escape backsticks and remove markdown headers, changing them to an all uppercase without the markers (so I do not break the chat window markdowng rendering).
--
-- The official codecompanion documentation mentions that I need to create a new prompt to achieve that, and configure it as a slash command as stated here: https://codecompanion.olimorris.dev/extending/prompts.html .

local telescope = require("telescope.builtin")
local system = require("prompts.system")

-- Configuration
local CONFIG = {
  context_register = "w", -- Register to store file content
  default_path = "~/.local/share/nvim/code-companion-chat-history/", -- Default path to show
}

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

-- Function to format markdown and text content
local function format_text_content(content, file_ext)
  if file_ext == "txt" or file_ext == "md" or file_ext == "markdown" then
    -- Escape backticks to prevent breaking markdown code blocks
    content = content:gsub("`", "\\`")

    -- Process lines to transform headers
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
      -- Check if line starts with markdown header markers (# to ######)
      local header_text = line:match("^%s*#+%s*(.*)")
      if header_text then
        -- Convert header text to uppercase
        table.insert(lines, header_text:upper())
      else
        table.insert(lines, line)
      end
    end

    -- Rejoin the lines
    content = table.concat(lines, "\n")
  end

  return content
end

return {
  strategy = "chat",
  description = "add contents of file outside the current cwd() \nas context to the current chat\n(custom slash command)",
  opts = {
    short_name = "file-add-to-context",
    auto_submit = false, -- Manual submission
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
        local path = vim.fn.input("Enter directory path: ", CONFIG.default_path)
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

        if #file_paths == 0 then
          vim.notify("No files found in directory: " .. dir_name, vim.log.levels.WARN)
          return "No files found in directory: " .. dir_name
        end

        -- Create a mapping of display names to full paths
        local display_to_path = {}
        local display_names = {}

        for _, file_path in ipairs(file_paths) do
          local display_name = file_path:sub(#dir_name + 1)
          display_to_path[display_name] = file_path
          table.insert(display_names, display_name)
        end

        -- Create a function to handle file selection
        _G.handle_file_selection = function(selection_value)
          local full_file_path = display_to_path[selection_value]

          if vim.fn.filereadable(full_file_path) == 1 then
            local telescope_selected_file_path = vim.fn.fnameescape(full_file_path)

            -- Build context message with file contents
            local context_message = "I'm adding the following file as context for our conversation:\n\n"

            local file = io.open(telescope_selected_file_path, "r")
            if file then
              local content = file:read("*all")
              file:close()

              -- Get file extension for language detection
              local file_ext = vim.fn.fnamemodify(telescope_selected_file_path, ":e")
              local lang_tag = file_ext ~= "" and file_ext or "text"

              -- Apply special formatting for text and markdown files
              content = format_text_content(content, file_ext)

              -- Format relative path
              local relative_path = telescope_selected_file_path:gsub("^" .. vim.fn.getcwd() .. "/", "")
              context_message = context_message
                .. "File: `"
                .. relative_path
                .. "`\n\n```"
                .. lang_tag
                .. "\n"
                .. content
                .. "\n```\n\n"
            else
              vim.notify("Failed to read file: " .. telescope_selected_file_path, vim.log.levels.ERROR)
              context_message = context_message .. "Failed to read file: " .. telescope_selected_file_path
            end

            context_message = context_message
              .. "Please acknowledge that you've received this file, "
              .. "summarize its contents and confirm you will use the full contents "
              .. "as context on our next interactions at this conversation."

            -- Store the result in the specified register
            vim.fn.setreg(CONFIG.context_register, context_message)

            vim.notify(
              "File context stored in register '"
                .. CONFIG.context_register
                .. "'. Use \""
                .. CONFIG.context_register
                .. "p to paste it."
            )
          else
            vim.notify("File does not exist: " .. full_file_path, vim.log.levels.ERROR)
          end
        end

        -- Display files in Telescope with exact matching in fuzzy search
        require("telescope.pickers")
          .new({}, {
            prompt_title = prompt_title,
            finder = require("telescope.finders").new_table({
              results = display_names,
            }),
            sorter = require("telescope.sorters").get_fuzzy_file({
              exact = true,
            }),
            previewer = require("telescope.previewers").new_buffer_previewer({
              define_preview = function(self, entry, status)
                local full_file_path = display_to_path[entry.value]
                local content = vim.fn.readfile(full_file_path)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
                local filetype = vim.fn.fnamemodify(full_file_path, ":e")
                vim.bo[self.state.bufnr].filetype = filetype
              end,
            }),
            attach_mappings = function(prompt_bufnr, map)
              local function get_selected_file_path()
                local selection = require("telescope.actions.state").get_selected_entry()
                vim.notify("Selection made: " .. vim.fn.fnamemodify(display_to_path[selection.value], ":t"))
                require("telescope.actions").close(prompt_bufnr)
                _G.handle_file_selection(selection.value)
              end
              map("i", "<CR>", get_selected_file_path)
              map("n", "<CR>", get_selected_file_path)
              return true
            end,
          })
          :find()

        return "(The content is now stored in register '"
          .. CONFIG.context_register
          .. "'. Use \""
          .. CONFIG.context_register
          .. "p to paste, then submit the message.)\n\n"
      end,
    },
  },
}
