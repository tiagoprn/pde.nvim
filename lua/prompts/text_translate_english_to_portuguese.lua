local system = require("prompts.system")

return {
  strategy = "chat",
  description = "translate english -> portuguese  -- chat, has_system_prompt",
  opts = {
    short_name = "translate-en_US-pt_BR",
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
      content = "Help me translate the text below from English to Brazilian Portuguese: ",
    },
  },
}
