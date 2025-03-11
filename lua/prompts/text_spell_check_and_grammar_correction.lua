local system = require("prompts.system")

return {
  strategy = "chat",
  description = "spell check and grammar correction  -- chat, has_system_prompt",
  opts = {
    short_name = "text-spell-grammar-semantics",
    auto_submit = false,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = system.SPELL_CHECK,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = "Review this text for spelling, grammar and semantics: ",
    },
  },
}
