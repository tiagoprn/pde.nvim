-- config: <https://github.com/nvim-mini/mini.files?tab=readme-ov-file#default-config>

require("mini.files").setup(
  -- No need to copy this inside `setup()`. Will be used automatically.
  {
    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    mappings = {
      close = "q",
      go_in = "l",
      go_in_plus = "L",
      go_out = "h",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },

    windows = {
      preview = true,
    },
  }
)
