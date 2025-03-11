local system = require("prompts.system")

return {
  strategy = "chat",
  description = "Suggest code architecture given a general use case  -- chat, has_system_prompt",
  opts = {
    short_name = "code-arch",
    auto_submit = true,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = system.CODE_ARCHITECTURE,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = "I will describe a general use case and I want you to suggest some code architecture suitable to its requirements",
    },
  },
}
