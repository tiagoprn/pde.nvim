local system = require("prompts.system")

return {
  strategy = "chat",
  description = "Boostrap (create) a new python script - chat, has_system_prompt",
  opts = {
    short_name = "new-python-script",
    auto_submit = false,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = system.BOOTSTRAP_PYTHON_SCRIPT,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = "Generate a python script that ",
    },
  },
}
