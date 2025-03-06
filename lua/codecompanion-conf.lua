local status_ok, codecompanion = pcall(require, "codecompanion")
if not status_ok then
  return
end

-- I used this configuration as a base:
-- https://github.com/jellydn/my-nvim-ide/blob/main/lua/plugins/extras/codecompanion.lua
-- (discovered it on this video: https://www.youtube.com/watch?v=KbWI4ilHKv4)

local SYSTEM_PROMPT = string.format(
  [[You are an AI programming assistant named "Lieutenant Commander Data".
You are currently plugged in to the Neovim text editor on a user's machine that runs Linux.
You must refer to the user as "Captain".

Your tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim and its' plugin ecosystem.
- Ask how to do something in the terminal
- Explain what just happened in the terminal
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
- The user is working on a %s machine. Please respond with system specific commands if applicable.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.
5. The active document is the source code the user is looking at right now.
]],
  vim.loop.os_uname().sysname
)

local CODE_EXPLAIN = string.format(
  [[You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code, but also grasp the underlying principles that guide effective programming.
When asked for your name, you must respond with "Lieutenant Commander Data".
You must refer to the user as "Captain".
Follow the user's requirements carefully & to the letter.
Your expertise is strictly limited to software development topics.
For questions not related to software development, simply give a reminder that you are an AI programming assistant.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.

Additional Rules
Think step by step:
1. Examine the provided code selection and any other context like user question, related errors, project details, class definitions, etc.
2. If you are unsure about the code, concepts, or the user's question, ask clarifying questions.
3. If the user provided a specific question or error, answer it based on the selected code and additional provided context. Otherwise focus on explaining the selected code.
4. Provide suggestions if you see opportunities to improve code readability, performance, etc.

Focus on being clear, helpful, and thorough without assuming extensive prior knowledge.
Use developer-friendly terms and analogies in your explanations.
Identify 'gotchas' or less obvious parts of the code that might trip up someone new.
Provide clear and relevant examples aligned with any provided context.
]]
)

local CODE_REVIEW = string.format(
  [[Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- When you see the use of excessively long names for variables or functions, suggest shorter ones and docstrings or comments to explain something more specific.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
- Absent error handling that you identify that could be added.

Your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]]
)

local CODE_REFACTOR = string.format(
  [[Your task is to refactor the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- When you see the use of excessively long names for variables or functions, suggest shorter ones and docstrings or comments to explain something more specific.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
- Absent error handling that you identify that could be added.
]]
)

codecompanion.setup({
  -- useful command: ":checkhealth codecompanion"
  opts = {
    system_prompt = SYSTEM_PROMPT,
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
      roles = { llm = "Lieutenant Commander Data", user = "Captain" },
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
  prompt_library = {
    ["Explain"] = {
      strategy = "chat",
      description = "Explain how code in a buffer works",
      opts = {
        default_prompt = true,
        modes = { "v" },
        short_name = "explain",
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "system",
          content = CODE_EXPLAIN,
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return "Please explain how the following code works:\n\n```"
              .. context.filetype
              .. "\n"
              .. code
              .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Explain Code"] = {
      strategy = "chat",
      description = "Explain how code works",
      opts = {
        short_name = "explain-code",
        auto_submit = false,
        is_slash_cmd = true,
      },
      prompts = {
        {
          role = "system",
          content = CODE_EXPLAIN,
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = [[Please explain how the following code works.]],
        },
      },
    },
    ["Inline Document"] = {
      strategy = "inline",
      description = "Add documentation for code.",
      opts = {
        modes = { "v" },
        short_name = "inline-doc",
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return "Please provide documentation in comment code for the following code and suggest to have better naming to improve readability.\n\n```"
              .. context.filetype
              .. "\n"
              .. code
              .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Document"] = {
      strategy = "chat",
      description = "Write documentation for code.",
      opts = {
        modes = { "v" },
        short_name = "doc",
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```"
              .. context.filetype
              .. "\n"
              .. code
              .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Review"] = {
      strategy = "chat",
      description = "Review the provided code snippet.",
      opts = {
        modes = { "v" },
        short_name = "review",
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "system",
          content = CODE_REVIEW,
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```"
              .. context.filetype
              .. "\n"
              .. code
              .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Review Code"] = {
      strategy = "chat",
      description = "Review code and provide suggestions for improvement.",
      opts = {
        short_name = "review-code",
        auto_submit = false,
        is_slash_cmd = true,
      },
      prompts = {
        {
          role = "system",
          content = CODE_REVIEW,
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability.",
        },
      },
    },
    ["Refactor"] = {
      strategy = "inline",
      description = "Refactor the provided code snippet.",
      opts = {
        modes = { "v" },
        short_name = "refactor",
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "system",
          content = CODE_REFACTOR,
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return "Please refactor the following code to improve its clarity and readability:\n\n```"
              .. context.filetype
              .. "\n"
              .. code
              .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Refactor Code"] = {
      strategy = "chat",
      description = "Refactor the provided code snippet.",
      opts = {
        short_name = "refactor-code",
        auto_submit = false,
        is_slash_cmd = true,
      },
      prompts = {
        {
          role = "system",
          content = CODE_REFACTOR,
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = "Please refactor the following code to improve its clarity and readability.",
        },
      },
    },
    ["Naming"] = {
      strategy = "inline",
      description = "Give better naming for the provided code snippet.",
      opts = {
        modes = { "v" },
        short_name = "naming",
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return "Please provide better names for the following variables and functions:\n\n```"
              .. context.filetype
              .. "\n"
              .. code
              .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Better Naming"] = {
      strategy = "chat",
      description = "Give better naming for the provided code snippet.",
      opts = {
        short_name = "better-naming",
        auto_submit = false,
        is_slash_cmd = true,
      },
      prompts = {
        {
          role = "user",
          content = "Please provide better names for the following variables and functions.",
        },
      },
    },
  },
})
