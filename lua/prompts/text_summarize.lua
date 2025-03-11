local system = require("prompts.system")

return {
  strategy = "chat",
  description = "summarize text  -- chat, has_system_prompt",
  opts = {
    short_name = "text-summary",
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
      content = "Summarize this text: ",
    },
  },
}
