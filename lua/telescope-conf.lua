require("telescope").load_extension("aerial")
require("telescope").load_extension("possession")
-- require("telescope").load_extension("bookmarks")

-- Open files in the same window/tab instead of on the current window
function open_buffer_selection(prompt_bufnr)
  -- print("---- PROMPT_BUFNR VALUE: " .. prompt_bufnr)

  local entry = require("telescope.actions.state").get_selected_entry(prompt_bufnr)

  if not entry then
    return
  end

  local buffer_number = entry.bufnr

  local buffer_name = vim.fn.bufname(buffer_number)
  local is_buffer_open = false

  for _, window in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(window) == buffer_number then
      vim.api.nvim_set_current_win(window)
      is_buffer_open = true
      print("Buffer '" .. buffer_name .. "' OPENED, switched to it!")
      break
    end
  end

  if not is_buffer_open then
    vim.cmd("tabnew | buffer " .. buffer_number)
    print("Buffer '" .. buffer_name .. "' NOT OPENED, so I opened it on a new tab!")
  end
end

-- Copy the selected Telescope entry to the clipboard
local function copy_to_clipboard()
  local entry = require("telescope.actions.state").get_selected_entry()
  if entry then
    local entry_value = entry.value
    local colon_index = entry_value:find(":")
    local contents = colon_index and entry_value:sub(colon_index + 1) or entry_value

    -- Remove remainder "line:column:" prefix if it exists
    contents = contents:gsub("^%d+:%d+:", "")

    vim.fn.setreg("+", contents)
    print("Copied to clipboard: " .. contents)
  end
end

-- Add custom actions to the Telescope pickers
local actions = require("telescope.actions")
local custom_actions = setmetatable({}, {
  __index = function(_, k)
    return function(prompt_bufnr)
      if k == "copy_to_clipboard" then
        copy_to_clipboard()
      else
        actions[k](prompt_bufnr)
      end
    end
  end,
})

require("telescope").setup({
  defaults = {
    layout_config = {
      -- prompt_position = "top",
      width = 0.9,
      height = 0.9,
      preview_cutoff = 120,
      horizontal = { mirror = false },
      vertical = { mirror = false },
    },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
        ["<C-y>"] = custom_actions.copy_to_clipboard,
      },
      n = {
        ["<C-y>"] = custom_actions.copy_to_clipboard,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<cr>"] = open_buffer_selection,
          ["<C-x>"] = require("telescope.actions").delete_buffer,
        },
        n = {
          ["<cr>"] = open_buffer_selection,
          ["<C-x>"] = require("telescope.actions").delete_buffer,
        },
      },
    },
    find_files = {
      layout_config = {
        prompt_position = "top",
        horizontal = {
          preview_width = 0.65,
        },
      },
    },
    live_grep = {
      layout_config = {
        prompt_position = "top",
        horizontal = {
          preview_width = 0.65,
        },
      },
    },
  },
  extensions = {
    fzf = {
      -- false will only do exact matching override the generic sorter
      -- override the file sorter or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    aerial = {
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = true,
    },
    import = {
      -- Add imports to the top of the file keeping the cursor in place: https://github.com/piersolenski/telescope-import.nvim/issues/2
      insert_at_top = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
  },
})

-- To get fzf loaded and working with telescope
require("telescope").load_extension("fzf")

-- To get ui-select loaded and working with telescope
require("telescope").load_extension("ui-select")
