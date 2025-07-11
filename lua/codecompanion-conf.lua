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
  -- code-related prompts
  "code_inline_document", -- inline
  "code_inline_explain", -- inline, has_system_prompt
  "code_inline_naming", -- inline
  "code_inline_refactor", -- inline, has_system_prompt
  "code_inline_review", -- inline, has_system_prompt
  "code_inline_scan_vulnerabilities", -- inline, has_system_prompt
  "code_better_naming", -- chat, has_system_prompt
  "code_document", -- chat
  "code_refactor", -- chat, has_system_prompt
  "code_review", -- chat, has_system_prompt
  "code_suggest_architecture", -- chat, has_system_prompt
  "code_explain", -- chat, has_system_prompt
  "code_bootstrap_python_script", -- chat, has_system_prompt
  "code_bootstrap_single_page_html_css_js", -- chat, has_system_prompt
  -- text-related prompts (migrated from dot_files/AI-PROMPTS)
  "text_translate_portuguese_to_english", -- chat, has_system_prompt
  "text_translate_english_to_portuguese", -- chat, has_system_prompt
  "text_spell_check_and_grammar_correction", -- chat, has_system_prompt
  "text_summarize", -- chat, has_system_prompt
  "text_generate_memory_summary_from_conversation", -- chat, has_system_prompt
  "text_create_flashcards", -- chat, has_system_prompt
  "text_add_file_as_context_to_current_chat", -- chat, has_system_prompt
  -- TODO: create inline versions of the text-related chat prompts above
}) do
  prompt_library[name] = require("prompts." .. name)
end

-- Disables diff-mode and also trigger auto-saving of buffers after changes (this is useful for the @editor tool)
vim.g.codecompanion_auto_tool_mode = true

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
      window = {
        layout = "horizontal", -- float|vertical|horizontal|buffer
        position = "bottom", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
        height = 0.4,
        -- width = 1.0,
        full_height = false, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
      },
    },
    diff = {
      enabled = true,
      layout = "vertical", -- vertical|horizontal split for default provider
      opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
      provider = "default", -- default|mini_diff
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
            default = "gpt-4.1-nano", -- (chatgpt-4o-latest , ...: check more using my curl navi cheat for openai)
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
            default = "claude-sonnet-4-20250514", -- check more using my curl navi cheat for anthropic (previous: claude-3-7-sonnet-20250219)
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
      tools = {
        ["editor"] = { -- https://codecompanion.olimorris.dev/usage/chat-buffer/agents#editor
          opts = {
            requires_approval = false,
          },
        },
        ["code_developer"] = require("tiagoprn.code_companion_editor_tool"),
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
