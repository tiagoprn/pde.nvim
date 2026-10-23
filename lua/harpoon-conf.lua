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

-- Single source of truth: each entry both binds the key inside the quick menu
-- and contributes its hint to the menu title below.
local menu_keys = {
  { lhs = "<C-v>", desc = "vsplit", select = { vsplit = true } },
  { lhs = "<C-x>", desc = "split", select = { split = true } },
  { lhs = "<C-t>", desc = "tabedit", select = { tabedit = true } },
}

harpoon:extend({
  UI_CREATE = function(cx)
    local hints = {}
    for _, item in ipairs(menu_keys) do
      vim.keymap.set("n", item.lhs, function()
        harpoon.ui:select_menu_item(item.select)
      end, { buffer = cx.bufnr, desc = item.desc })
      hints[#hints + 1] = item.lhs .. " " .. item.desc
    end

    -- Patch only the title; nvim_win_set_config updates just the given keys.
    local all_hints = { "<CR> open" }
    vim.list_extend(all_hints, hints)
    all_hints[#all_hints + 1] = "q quit"

    vim.api.nvim_win_set_config(cx.win_id, {
      title = " ⚓ HARPOON  |  " .. table.concat(all_hints, "  |  ") .. " ",
    })
  end,
})
