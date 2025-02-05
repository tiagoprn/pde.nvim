-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, codecompanion = pcall(require, "codecompanion")
if not status_ok then
  return
end

codecompanion.setup({
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        env = {
          api_key = "cmd:pass api-keys/OPENAI 2>/dev/null",
        },
        schema = {
          model = {
            default = "gpt-4",
          },
        },
      })
    end,
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = "cmd:pass api-keys/anthropic 2>/dev/null",
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "anthropic", -- default. options: openai, anthropic
    },
    inline = {
      adapter = "anthropic", -- default. options: openai, anthropic
    },
  },
  saved_chats = {
    save_dir = vim.fn.getenv("HOME") .. "/nvim-codecompanion/saved_chats", -- Path to save chats to
  },
})
