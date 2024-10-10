-- IMPORTANT:
--   TreeSitter is what allows a better syntax highlighting on neovim.
--   Both commands below require the package "npm" installed on your linux distribution:
--     To see all available languages list: `:TSInstallInfo`
--     To install a new language from the list: `TSInstall <language>`

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local has_parser = pcall(require("nvim-treesitter.parsers").get_parser, buf)
      if not has_parser then
        vim.notify("No Treesitter parser found for " .. lang, vim.log.levels.WARN)
        return true
      end
      return false
    end,
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = "all",
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  query_linter = { -- treesitter-playground
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
})
