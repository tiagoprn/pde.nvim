local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local M = {} -- creates a new table here to isolate from the global scope
--
-- This is a custom telescope picker that leverages rg with cli parameters to search on files on cwd
--
-- Based on this video: https://www.youtube.com/watch?v=xdXE1tOT-qg&list=PLJI2RX4Ltq-mNjxPcO6iRnr8TZe9FZoHk&index=5
function M.live_multigrep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  -- Debug output to check cwd
  vim.api.nvim_echo({ { string.format("cwd is now: %s", opts.cwd), "Normal" } }, true, {})

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      -- Always return a base command even with empty prompt
      local args = { "rg" }

      if prompt and prompt ~= "" then
        local pieces = vim.split(prompt, "  ")
        if pieces[1] then
          table.insert(args, "-e")
          table.insert(args, pieces[1])
        end
        if pieces[2] then
          table.insert(args, "-g")
          table.insert(args, pieces[2])
        end
      end

      -- Add default arguments
      local cmd = vim.tbl_flatten({
        args,
        { "--color-never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      })

      -- Debug output to check what command is being generated
      vim.api.nvim_echo({ { vim.inspect(cmd), "Normal" } }, true, {})

      return cmd
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Live Multi Grep (e.g. use <space><space>.py after the text to filter for python files)",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(), -- no sorter, since rg will do that
    })
    :find()
end

return M
