local system = require("prompts.system")

return {
  strategy = "chat",
  description = "Give better naming for the provided code snippet  -- chat, has_system_prompt",
  opts = {
    short_name = "code-name",
    auto_submit = false,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "user",
      content = "Please provide better names for the following variables and functions.",
    },
  },
}
