local system = require("prompts.system")

return {
  strategy = "chat",
  description = "memory summary from conversation  -- chat, has_system_prompt",
  opts = {
    short_name = "text-memory-conversation",
    auto_submit = false,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = system.NATURAL_LANGUAGE,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = "Please generate a memory summary of this conversation: ",
    },
  },
}
