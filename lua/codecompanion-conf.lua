-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, codecompanion = pcall(require, "codecompanion")
if not status_ok then
  return
end

-- I can use this configuration as a reference:
-- https://github.com/jellydn/my-nvim-ide/blob/main/lua/plugins/extras/codecompanion.lua
-- (discovered it on this video: https://www.youtube.com/watch?v=KbWI4ilHKv4)

codecompanion.setup({
  -- useful command: ":checkhealth codecompanion"
  -- opts = {
  --   log_level = "DEBUG", -- or "TRACE", it is located at: "$HOME/.local/state/nvim/codecompanion.log"
  -- },
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ", -- Prompt used for interactive LLM calls
      provider = "telescope", -- default|telescope|mini_pick
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
    chat = {
      show_settings = true,
    },
  },
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        env = {
          api_key = "cmd:pass api-keys/OPENAI 2>/dev/null",
        },
        schema = {
          model = {
            default = "chatgpt-4o-latest", -- (gpt-4, ...: check more using my curl navi cheat for openai)
          },
        },
      })
    end,
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = "cmd:pass api-keys/anthropic 2>/dev/null",
        },
        schema = {
          model = {
            default = "claude-3-7-sonnet-20250219 ", -- check more using my curl navi cheat for anthropic (previous: claude-3-5-sonnet-20241022)
          },
        },
      })
    end,
    deepseek = function()
      return require("codecompanion.adapters").extend("deepseek", {
        env = {
          api_key = "cmd:pass api-keys/deepseek 2>/dev/null",
        },
        schema = {
          model = {
            default = "deepseek-reasoner", -- deepseek-chat, deepseek-reasoner
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "anthropic", -- default. options: openai, anthropic, deepseek
    },
    inline = { -- As of 2025-03-05, anthropic is not working as an inline provider (just for chat)
      adapter = "openai", -- default. options: openai, anthropic, deepseek.
      keymaps = {
        accept_change = {
          modes = { n = "ga" },
          description = "CODECOMPANION - Accept all suggested changes",
        },
        reject_change = {
          modes = { n = "gr" },
          description = "CODECOMPANION - Rejects all suggested changes",
        },
      },
    },
  },
})
