--
-- This is a custom telescope picker that leverages rg with cli parameters to search on files on cwd
-- I can use it as a base to create custom searches using rg and glob filters.
--
-- Based on this video: https://www.youtube.com/watch?v=xdXE1tOT-qg&list=PLJI2RX4Ltq-mNjxPcO6iRnr8TZe9FZoHk&index=5

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local M = {} -- creates a new table here to isolate from the global scope

function M.live_multigrep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  -- Debug output to check cwd
  -- vim.api.nvim_echo({ { string.format("cwd is now: %s", opts.cwd), "Normal" } }, true, {})

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      -- Always return a base command even with empty prompt
      local args =
        { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }

      if prompt and prompt ~= "" then
        local pieces = vim.split(prompt, "  ")
        -- Add glob pattern first if it exists
        if pieces[2] then
          table.insert(args, "-g")
          table.insert(args, pieces[2])
        end
        -- Then add search pattern
        if pieces[1] then
          table.insert(args, "-e")
          table.insert(args, pieces[1])
        end
      end

      -- Debug output to show full command context
      -- local cmd_str = table.concat(args, " ")
      -- vim.api.nvim_echo({ { string.format("Running: %s in directory: %s", cmd_str, opts.cwd), "Normal" } }, true, {})

      return args
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      debounce = 100, -- time to wait when I type the prompt
      prompt_title = "Live Multi Grep (e.g. use <SPACE><SPACE>.PY after the text to filter for python files)",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(), -- no sorter, since rg will do that
    })
    :find()
end

return M
