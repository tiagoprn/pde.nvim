local system = require("prompts.system")

return {
  strategy = "inline",
  description = "Scan security vulnerabilities on the provided code snippet  -- inline, has_system_prompt",
  opts = {
    modes = { "v" },
    short_name = "code-inline-sec-scan",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = "system",
      content = system.SECURITY_SCAN,
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

        return "Please review the following code for security vulnerabilities:\n\n```"
          .. context.filetype
          .. "\n"
          .. code
          .. "\n```\n\n"
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
