-- I want to create a slash command with codecompanion.nvim to be able to select a file from a specific path (path must be entered prior to open telescope to select the files).
-- The contents of the files I select with telescope will then be available as context for my future prompts.
-- I have an example of a custom prompt I created here on text_create_flashcards.lua.
-- The documention mentions that I need to create a new prompt and configure it as a slash commands here: https://codecompanion.olimorris.dev/extending/prompts.html .
-- Can you help me to implement this on this file?

local system = require("prompts.system")

return {
  strategy = "chat",
  description = "Add files as context to the current chat",
  opts = {
    short_name = "files-add-to-context",
    auto_submit = false,
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
        local path = vim.fn.input("Enter directory path: ", vim.fn.getcwd())
        if not path or path == "" then
          return nil
        end

        path = vim.fn.expand(path)
        if vim.fn.isdirectory(path) ~= 1 then
          vim.notify("Invalid directory path: " .. path, vim.log.levels.ERROR)
          return nil
        end

        -- Use telescope to select files
        local selected_files = {}
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        local picker = pickers.new({}, {
          prompt_title = "Select Files to Add as Context",
          finder = finders.new_oneshot_job({ "find", path, "-type", "f", "-not", "-path", "*/\\.*" }, {}),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              if selection then
                local file_path = selection.value
                table.insert(selected_files, file_path)
                vim.notify("Selected: " .. file_path, vim.log.levels.INFO)
              end
              return true -- Keep the picker open
            end)

            -- Add custom mapping to confirm selection and close picker
            map("i", "<C-d>", function()
              actions.close(prompt_bufnr)
            end)

            return true
          end,
        })

        picker:find()

        -- Wait for picker to close and process selected files
        vim.wait(1000, function()
          return not picker.prompt_bufnr
        end)

        if #selected_files == 0 then
          vim.notify("No files selected", vim.log.levels.WARN)
          return nil
        end

        -- Build context message with file contents
        local context_message = "I'm adding the following files as context for our conversation:\n\n"

        for _, file_path in ipairs(selected_files) do
          local file = io.open(file_path, "r")
          if file then
            local content = file:read("*all")
            file:close()

            local relative_path = file_path:gsub("^" .. vim.fn.getcwd() .. "/", "")
            context_message = context_message .. "File: " .. relative_path .. "\n```\n" .. content .. "\n```\n\n"
          end
        end

        context_message = context_message
          .. "Please acknowledge that you've received these files and will use them as context for our future conversation."

        return context_message
      end,
    },
  },
}
