local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
  return
end

-- Keymaps: https://github.com/obsidian-nvim/obsidian.nvim?tab=readme-ov-file#keymaps
-- To disable smart_action on <CR> and remap it to <leader><CR>, with only the checkbox specific behavior
vim.api.nvim_create_autocmd("User", {
  pattern = "ObsidianNoteEnter",
  callback = function(ev)
    -- Delete the default <CR> mapping for the current buffer
    vim.keymap.del("n", "<CR>", { buffer = ev.buf })

    require("which-key").add({
      {
        "<leader><cr>",
        ":ObsidianToggleCheckbox<CR>",
        desc = "OBSIDIAN: toggle markdown checkbox",
        buffer = ev.buf, -- Crucially, this makes the mapping buffer-local
      },
    })
  end,
})

obsidian.setup({
  ui = { enable = false }, -- disables the plugin's markdown renderer, so that I can keep using markview.nvim
  workspaces = {
    {
      name = "codex",
      path = "/storage/src/codex",
      overrides = {
        notes_subdir = "0-inbox",
      },
    },
  },
  new_notes_location = "notes_subdir",
  completion = {
    blink = false, -- TODO: changed because of bug on blink completion that started at 2025-06-06. revert back to "true" when that is solved.
    min_chars = 2,
    prepend_note_id = true,
  },
  -- Either 'wiki' or 'markdown'.
  preferred_link_style = "wiki",
  -- Below is due to https://github.com/epwalsh/obsidian.nvim/pull/406
  wiki_link_func = function(opts)
    if opts.id == nil then
      return string.format("[[%s]]", opts.label)
    elseif opts.label ~= opts.id then
      return string.format("[[%s|%s]]", opts.id, opts.label)
    else
      return string.format("[[%s]]", opts.id)
    end
  end,
  -- customizes how notes ids are generated
  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    -- In this case a note with the title 'My new note' will be given an ID that looks
    -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    local formatted_time = os.date("%Y%m%d-%a-%H%M%S", os.time()) -- E.g. 20241101-Fri-064114
    return tostring(formatted_time) .. "-" .. suffix
  end,
  -- customizes how note frontmatter is generated
  note_frontmatter_func = function(note)
    -- Add the title of the note as an alias.
    if note.title then
      note:add_alias(note.title)
    end

    local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }

    -- `note.metadata` contains any manually added fields in the frontmatter.
    -- So here we just make sure those fields are kept in the frontmatter.
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end

    return out
  end,

  templates = {
    folder = "Templates",
    date_format = "%Y-%m-%d-%A",
    time_format = "%H:%M",
    tags = "",
  },
})
