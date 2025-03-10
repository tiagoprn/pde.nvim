local status_ok, codecompanion = pcall(require, "codecompanion")
if not status_ok then
  return
end

-- I used this configuration as a base:
-- https://github.com/jellydn/my-nvim-ide/blob/main/lua/plugins/extras/codecompanion.lua
-- (discovered it on this video: https://www.youtube.com/watch?v=KbWI4ilHKv4)

local system = require("prompts.system")

local prompt_library = {}
for _, name in ipairs({
  "better_naming", -- chat, has_system_prompt
  "document", -- chat
  "explain", -- chat, has_system_prompt
  "explain_code", -- chat, has_system_prompt
  "inline_document", -- inline
  "inline_naming", -- inline
  "inline_refactor", -- inline, has_system_prompt
  "refactor_code", -- chat, has_system_prompt
  "inline_review", -- inline, has_system_prompt
  "review_code", -- chat, has_system_prompt
}) do
  prompt_library[name] = require("prompts." .. name)
end

codecompanion.setup({
  -- useful command: ":checkhealth codecompanion"
  opts = {
    system_prompt = system.SYSTEM_PROMPT,
    --   log_level = "DEBUG", -- or "TRACE", it is located at: "$HOME/.local/state/nvim/codecompanion.log"
  },
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ", -- Prompt used for interactive LLM calls
      provider = "telescope", -- default|telescope|mini_pick
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = false, -- Show the default prompt library in the action palette?
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
      roles = {
        llm = function(adapter)
          return ":::LIUTENANT COMMANDER DATA::: (" .. adapter.formatted_name .. " adapter) "
        end,
        user = ":::CAPTAIN:::",
      },
      slash_commands = {
        ["buffer"] = {
          callback = "strategies.chat.slash_commands.buffer",
          description = "Insert open buffers",
          opts = {
            contains_code = true,
            provider = "telescope", -- default|telescope|mini_pick|fzf_lua
          },
        },
        ["file"] = {
          callback = "strategies.chat.slash_commands.file",
          description = "Insert a file",
          opts = {
            contains_code = true,
            max_lines = 1000,
            provider = "telescope", -- telescope|mini_pick|fzf_lua
          },
        },
      },
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
  --
  prompt_library = prompt_library,
})
