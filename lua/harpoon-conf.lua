-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
  return
end

local harpoon_extensions = require("harpoon.extensions")

harpoon.setup({})

-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#extend

harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

harpoon:extend({
  UI_CREATE = function(cx)
    vim.keymap.set("n", "<C-v>", function()
      harpoon.ui:select_menu_item({ vsplit = true })
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<C-x>", function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<C-t>", function()
      harpoon.ui:select_menu_item({ tabedit = true })
    end, { buffer = cx.bufnr })
  end,
})
