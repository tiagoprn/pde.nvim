-- custom commands
-- TODO: migrate the following vim files to here:
--    commands.vim
--    commands-tiagoprn-functions.vim

local custom_command = vim.api.nvim_create_user_command

custom_command("TestCommand", function()
  print("This is a test")
end, {})

-- telescope_search_on_local_clipboard_files()
custom_command("TelescopeSelectLocalClipboardFiles", function()
  require("telescope.builtin").find_files({
    find_command = { "find", "/tmp", "-type", "f", "-name", "copied*" },
    previewer = true, -- Enable the preview pane
  })
end, {})
