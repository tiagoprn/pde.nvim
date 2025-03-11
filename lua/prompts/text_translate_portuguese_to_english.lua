local system = require("prompts.system")

return {
  strategy = "chat",
  description = "translate portuguese -> english  -- chat, has_system_prompt",
  opts = {
    short_name = "translate-pt_BR-en_US",
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
      content = "Help me translate the text below from Brazilian Portuguese to English: ",
    },
  },
}
