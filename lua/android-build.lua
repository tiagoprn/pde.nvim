-- Build/install/logcat shortcuts for Android Gradle projects.
-- Commands: :AndroidBuild  :AndroidInstall  :AndroidLogcat
-- Mapped under the which-key group "<leader>A" (Android Dev Commands)
-- in lua/key-mappings-conf.lua.
local M = {}

local function project_root()
  local root = vim.fs.root(0, { "settings.gradle.kts", "settings.gradle" })
  if not root then
    vim.notify("Not inside a Gradle project", vim.log.levels.WARN)
  end
  return root
end

function M.build()
  local root = project_root()
  if not root then return end
  vim.cmd("AsyncRun -cwd=" .. root .. " ./gradlew assembleDebug")
  vim.cmd("copen")
end

function M.install()
  local root = project_root()
  if not root then return end
  vim.cmd("AsyncRun -cwd=" .. root .. " ./gradlew installDebug")
  vim.cmd("copen")
end

function M.logcat()
  vim.cmd("terminal adb logcat -c && adb logcat")
end

vim.api.nvim_create_user_command("AndroidBuild", M.build, { desc = "Gradle assembleDebug" })
vim.api.nvim_create_user_command("AndroidInstall", M.install, { desc = "Gradle installDebug" })
vim.api.nvim_create_user_command("AndroidLogcat", M.logcat, { desc = "Clear and follow logcat" })

return M
