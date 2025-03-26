-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, noice = pcall(require, "noice")
if not status_ok then
  return
end

-- we can also create custom "routes", so to e.g. hide some messages or process them. More on that here:
-- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#hide-written-messages-1

noice.setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    message = {
      -- Messages shown by lsp servers
      enabled = true,
      view = "split",
      opts = {},
    },
    progress = {
      enabled = true,
      -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
      -- See the section on formatting for more details on how to customize.
      format = "lsp_progress",
      format_done = "lsp_progress_done",
      throttle = 1000 / 30, -- frequency to update lsp progress message
      view = "split",
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = true, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  messages = {
    -- NOTE: If you enable messages, then the cmdline is enabled automatically.
    -- This is a current Neovim limitation.
    enabled = true, -- enables the Noice messages UI
    view = "notify", -- default view for messages
    view_error = "notify", -- view for errors
    view_warn = "notify", -- view for warnings
    view_history = "messages", -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
  notify = {
    -- Noice can be used as `vim.notify` so you can route any notification like other messages
    -- Notification messages have their level and other properties set.
    -- event is always "notify" and kind can be any log level as a string
    -- The default routes will forward notifications to nvim-notify
    -- Benefit of using Noice for this is the routing and consistent history view
    enabled = true,
    view = "notify",
  },
  views = { -- check available options at https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua
    cmdline_popup = {
      position = {
        -- row = "100%",
        row = "50%",
        col = "50%",
      },
    },
    split = {
      relative = "editor",
      size = "10%",
    },
    mini = {
      relative = "editor",
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      position = {
        row = 2,
        col = "100%",
        -- col = 0,
      },
    },
    notify = {
      merge = true,
    },
  },
})
