local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
  return
end

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
  completion = {
    nvim_cmp = true,
    min_chars = 2,
    new_notes_location = "notes_subdir",
    prepend_note_id = true,
  },
  -- Either 'wiki' or 'markdown'.
  preferred_link_style = "wiki",
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
    local formatted_time = os.date("%Y%m%d-%H%M%S", os.time())
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
