local system = require("prompts.system")

return {
  strategy = "chat",
  description = "Boostrap (create) a single page HTML/CSS/JS - chat, has_system_prompt",
  opts = {
    short_name = "new-html-css-js",
    auto_submit = false,
    is_slash_cmd = true,
  },
  prompts = {
    {
      role = "system",
      content = system.BOOTSTRAP_SINGLE_PAGE_HTML_CSS_JS,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = [[Write me a one-file html artifact that ... e.g. asks for the user name in a text input, makes him choose between 3 random words, then according to the time of the day it shows the user the message: "Hello user <user name here>, you chose the word <word chosen here>. Have a great <morning, noon, afternoon, etc>".]],
    },
  },
}
