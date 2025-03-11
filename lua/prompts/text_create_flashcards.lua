local system = require("prompts.system")

return {
  strategy = "chat",
  description = "create flashcards  -- chat, has_system_prompt",
  opts = {
    short_name = "text-flashcard",
    auto_submit = true,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = system.CREATE_FLASHCARDS,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = "Generate flashcards from this text: ",
    },
  },
}
