local M = {}

-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, chatgpt = pcall(require, "chatgpt")
if not status_ok then
  return
end

function M.setup()
  chatgpt.setup({
    api_key_cmd = "pass api-keys/OPENAI",
    openai_params = {
      -- NOTE: model can be a function returning the model name
      -- this is useful if you want to change the model on the fly
      -- using commands
      -- Example:
      -- model = function()
      --     if some_condition() then
      --         return "gpt-4-1106-preview"
      --     else
      --         return "gpt-3.5-turbo"
      --     end
      -- end,
      model = "gpt-4o", -- check navi command search "chatgpt" to get all available models according to their API
      frequency_penalty = 0,
      presence_penalty = 0,
      max_tokens = 4095,
      temperature = 0.2,
      top_p = 0.1,
      n = 1,
    },
    actions_paths = { "/storage/src/pde.nvim/chatgpt/custom_actions.json" },
  })
end

return M
