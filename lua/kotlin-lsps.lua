-- Kotlin language server (fwcd community build): https://github.com/fwcd/kotlin-language-server
-- Install: see the "#### kotlin" section in README.md (release zip + symlink into ~/.local/bin).
local cmd = "kotlin-language-server"

if vim.fn.executable(cmd) ~= 1 then
  require("utils").write_log(cmd .. " not found on PATH; Kotlin LSP not enabled")
  return
end

vim.lsp.config("kotlin_language_server", {
  cmd = { cmd },
  -- Server-only JDK pin: the bundled Kotlin compiler 2.1.0 rejects Java 25
  -- (IllegalArgumentException in JavaVersion.parse), so run this client on JDK 21.
  -- This env applies only to the LSP process, not to the shell/Gradle (still JAVA_HOME=25).
  cmd_env = { JAVA_HOME = "/usr/lib/jvm/java-21-openjdk" },
  filetypes = { "kotlin" },
  root_markers = {
    "settings.gradle.kts",
    "settings.gradle",
    "build.gradle.kts",
    "build.gradle",
    "pom.xml",
    ".git",
  },
  capabilities = (function()
    local cap = vim.lsp.protocol.make_client_capabilities()
    cap = vim.tbl_deep_extend("force", cap, require("blink.cmp").get_lsp_capabilities({}, false))
    cap = vim.tbl_deep_extend("force", cap, {
      offsetEncoding = { "utf-16" },
      general = { positionEncodings = { "utf-16" } },
    })
    return cap
  end)(),
  init_options = {
    storagePath = vim.fs.root(vim.fn.expand("%:p:h"), { "settings.gradle.kts", ".git" }),
  },
})
vim.lsp.enable("kotlin_language_server")
