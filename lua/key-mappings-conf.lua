-- This has all my custom keymappings, configured using which-key

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

-- --
-- 1) WHICH-KEY mappings (can/must be triggered with the LEADER key)
-- --
which_key.setup({
  -- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
  -- window = {
  -- 	border = "single", -- none, single, double, shadow
  -- },
  -- layout = {
  -- 	height = { min = 4, max = 25 }, -- min and max height of the columns
  -- 	width = { min = 20, max = 80 }, -- min and max width of the columns
  -- 	spacing = 3, -- spacing between columns
  -- 	align = "center", -- align columns left, center or right
  -- },
  preset = "classic",
  layout = {
    width = { min = 20, max = 80 }, -- min and max width of the columns
  },
  win = {
    border = "double",
  },
})

which_key.add({
  -- automations
  { "<leader>a", group = "automations" },
  { "<leader>ac", group = "commands (flow)" },
  { "<leader>aca", ":FlowRunLastCmd<cr>", desc = "(flow) run last command" },
  { "<leader>acf", ":FlowRunFile<cr>", desc = "(flow) run current file on new buffer" },
  {
    "<leader>ach",
    "<cmd>lua require('tiagoprn.helpers').firefox('https://www.youtube.com/watch?v=GE5E1ZhV_Ok')<cr>",
    desc = "(flow) open YouTube video explaining how to use this plugin",
  },
  { "<leader>acl", ":FlowLauncher<cr>", desc = "(flow) run launcher" },
  { "<leader>aco", ":FlowLastOutput<cr>", desc = "(flow) show last output" },
  -- { "<leader>ai", group = "AI (avante)" },
  --
  -- { "<leader>aig", group = "AI (ChatGPT)" },
  -- { "<leader>aiga", "<cmd>ChatGPTRun chat_with_selection<cr>", desc = "Chat with selection", mode = { "v" } },
  -- { "<leader>aigc", "<cmd>ChatGPTRun complete_code<cr>", desc = "Create/Complete Code", mode = { "n", "v" } },
  -- { "<leader>aige", "<cmd>ChatGPTEditWithInstruction<cr>", desc = "Edit with instruction", mode = { "n", "v" } },
  -- { "<leader>aigg", "<cmd>ChatGPTRun grammar_correction<cr>", desc = "Grammar Correction", mode = { "n", "v" } },
  -- { "<leader>aigt", "<cmd>ChatGPTRun translate<cr>", desc = "Translate", mode = { "n", "v" } },
  -- { "<leader>aigk", "<cmd>ChatGPTRun keywords<cr>", desc = "Keywords", mode = { "n", "v" } },
  -- { "<leader>aigd", "<cmd>ChatGPTRun docstring<cr>", desc = "Docstring", mode = { "n", "v" } },
  -- { "<leader>aigT", "<cmd>ChatGPTRun add_tests<cr>", desc = "Add Tests", mode = { "n", "v" } },
  -- { "<leader>aigo", "<cmd>ChatGPTRun optimize_code<cr>", desc = "Optimize Code", mode = { "n", "v" } },
  -- { "<leader>aigs", "<cmd>ChatGPTRun summarize<cr>", desc = "Summarize", mode = { "n", "v" } },
  -- { "<leader>aigf", "<cmd>ChatGPTRun fix_bugs<cr>", desc = "Fix Bugs", mode = { "n", "v" } },
  -- { "<leader>aigx", "<cmd>ChatGPTRun explain_code<cr>", desc = "Explain Code", mode = { "n", "v" } },
  -- {
  --   "<leader>aigl",
  --   "<cmd>ChatGPTRun code_readability_analysis<cr>",
  --   desc = "Code Readability Analysis",
  --   mode = { "n", "v" },
  -- },
  { "<leader>ai", group = "AI (CODE COMPANION)" },
  { "<leader>aia", ":CodeCompanionActions<cr>", desc = "Select Action" },
  { "<leader>aih", "<cmd>lua require('tiagoprn.forms').codecompanion_help()<cr>", desc = "help" },
  { "<F10>", ":CodeCompanionChat<cr>", desc = "Toggle" },

  { "<leader>al", ":PrintLspSupportedRequests<cr>", desc = "print all supported requests on the current LSP server" },
  { "<leader>at", group = "tmux" },
  {
    "<leader>ati",
    ":RunInteractiveCommandOnCurrentFunctionOrMethodAtTmuxScratchpadSession<cr>",
    desc = "run interactive command on current function or method at tmux scratchpad session",
  },
  {
    "<leader>atl",
    ":RerunLastCommandOnTmuxScratchpadSession<cr>",
    desc = "rerun last bash command on tmux scratchpad session",
  },
  {
    "<leader>atp",
    ":RunPytestOnCurrentFunctionOrMethodAtTmuxScratchpadSession<cr>",
    desc = "run pytest on current function or method at tmux scratchpad session",
  },
  { "<leader>atr", ":RunCommandOnTmuxScratchpadSession<cr>", desc = "run bash command on tmux scratchpad session" },
  -- clipboard
  { "<leader>b", group = "clipboard" },
  {
    "<leader>bf",
    "<cmd>lua require('tiagoprn.buffer_utils').copy_default_clipboard_register_to_file()<cr>",
    desc = "copy contents of default clipboard register to /tmp/copied.txt",
  },
  {
    "<leader>ba",
    "<cmd>lua require('tiagoprn.buffer_utils').copy_current_buffer_absolute_path()<cr>",
    desc = "copy current buffer absolute path to /tmp/copied.txt",
  },
  {
    "<leader>br",
    "<cmd>lua require('tiagoprn.buffer_utils').copy_current_buffer_relative_path()<cr>",
    desc = "copy current buffer relative path to /tmp/copied.txt",
  },
  {
    "<leader>bn",
    "<cmd>lua require('tiagoprn.buffer_utils').copy_current_buffer_name()<cr>",
    desc = "copy current buffer name to /tmp/copied.txt",
  },
  {
    "<leader>bA",
    "<cmd>lua require('tiagoprn.buffer_utils').copy_current_buffer_absolute_path_with_position()<cr>",
    desc = "copy current buffer absolute path (WITH POSITION) to /tmp/copied.txt",
  },
  {
    "<leader>bR",
    "<cmd>lua require('tiagoprn.buffer_utils').copy_current_buffer_relative_path_with_position()<cr>",
    desc = "copy current buffer relative path (WITH POSITION) to /tmp/copied.txt",
  },
  {
    "<leader>bN",
    "<cmd>lua require('tiagoprn.buffer_utils').copy_current_buffer_name_with_position()<cr>",
    desc = "copy current buffer name (WITH POSITION) to /tmp/copied.txt",
  },
  { "<leader>be", ":Telescope registers<cr>", desc = "telescope browse registers" },
  {
    "<leader>bg",
    ":let @+=system(\"git symbolic-ref --short HEAD 2>/dev/null | tr -d '\\n'\")<cr>",
    desc = "copy current git branch name to clipboard",
  },
  {
    "<leader>bG",
    ":let @+=system(\"git symbolic-ref --short HEAD 2>/dev/null | tr -d '\\n' | sed 's|/|.|g' \")<cr>",
    desc = "copy current git branch name to clipboard (replacing / character with .)",
  },
  { "<leader>bl", ":let @+=line('.')<cr>", desc = "current line number" },
  { "<leader>bp", '"+p', desc = "paste from system clipboard" },
  -- coding
  { "<leader>c", group = "coding" },
  { "<leader>cA", ":Lspsaga code_action<cr>", desc = "code action" },
  {
    "<leader>ca",
    ":Telescope lsp_workspace_symbols<cr>",
    desc = "telescope project navigation through symbols (classes, functions etc)",
  },
  { "<leader>cc", ":RunSelectPythonClass<cr>", desc = "Go to python class on current file" },
  { "<leader>cd", group = "go to definition" },
  {
    "<leader>cdf",
    "<cmd>lua require('goto-preview').goto_preview_definition()<cr>",
    desc = "LSP open on floating window",
  },
  { "<leader>cdo", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "LSP open on current window" },
  { "<leader>cdq", "<cmd>lua require('goto-preview').close_all_win()<cr>", desc = "LSP close all floating windows" },
  {
    "<leader>cdt",
    '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="tab"})<cr>',
    desc = "LSP open on tab",
  },
  {
    "<leader>cdv",
    '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<cr>',
    desc = "LSP open on vertical window",
  },
  {
    "<leader>cdx",
    '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="split"})<cr>',
    desc = "LSP open on horizontal window",
  },
  { "<leader>ce", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "go to declaration" },
  { "<leader>cf", "<cmd>lua vim.lsp.buf.format(nil,1200)<cr>", desc = "format file (null-ls)" },
  {
    "<leader>cg",
    ":GeneratePythonProjectDefinitionsFile<cr>",
    desc = "Python Project Search: create/update python project definitions.txt file",
  },
  { "<leader>ch", ":Lspsaga hover_doc<cr>", desc = "documentation hover" },
  { "<leader>ci", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "go to implementation" },
  { "<leader>cl", ":LspInfo <cr>", desc = "LSP info" },
  { "<leader>cm", ":Telescope make<cr>", desc = "telescope run Makefile command" },
  {
    "<leader>cn",
    ":Telescope lsp_document_symbols<cr>",
    desc = "telescope buffer navigation through symbols (classes, functions etc)",
  },
  {
    "<leader>co",
    ":Telescope import<cr>",
    desc = "search for import on project and add to the top imports on this module",
  },
  { "<leader>cq", "<cmd>lua vim.diagnostic.setqflist()<cr>", desc = "send linter/diagnostics to quickfix list" },
  {
    "<leader>cr",
    ":Telescope lsp_references<cr>",
    desc = "telescope search references to the current word (class, function, variable, etc)",
  },
  {
    "<leader>cs",
    ":PythonProjectSearch<cr>",
    desc = "Python Project Search: search and open a python class, method or function",
  },
  { "<leader>ct", group = "treesitter" },
  { "<leader>ctn", ":TSNodeUnderCursor<cr>", desc = "current node info" },
  { "<leader>ctp", ":TSPlaygroundToggle<cr>", desc = "toggle playground" },
  { "<leader>cu", ":NullLsInfo <cr>", desc = "null-ls info" },
  -- etc
  { "<leader>e", group = "etc" },
  { "<leader>ec", ":Telescope colorscheme<cr>", desc = "telescope browse color schemes" },
  { "<leader>eh", ":Telescope help_tags<cr>", desc = "telescope search tag on nvim help (builtins and plugins)" },
  -- files, buffers, tabs & windows
  -- -- files
  { "<leader>f", group = "files, buffers, tabs & windows" },
  {
    "<leader>fc",
    "<cmd>lua require('tiagoprn.buffer_utils').save_buffer_copy_to_tmp()<cr>",
    desc = "Save buffer copy to /tmp",
  },
  {
    "<leader>ff",
    ":Telescope find_files find_command=fd,-H,-E,.git prompt_prefix=fd: <cr>",
    desc = "telescope open files",
  },
  {
    "<leader>fg",
    ":<cmd>lua require('tiagoprn.code_utils').open_git_changed_files_with_telescope()<cr>",
    desc = "(git) telescope open changed files",
  },

  { "<leader>fo", ":!gedit %<cr>", desc = "open current file on gedit" },
  {
    "<leader>fr",
    ":Easypick recent_files_on_current_folder<cr>",
    desc = "telescope open files changed recently (<=14 days) ",
  },
  { "<leader>fs", ":SearchOnOpenFiles<cr>", desc = "search on open files" },
  -- -- buffers
  { "<leader>fb", group = "buffers" },
  { "<leader>fbK", ":bp<bar>sp<bar>bn<bar>bd<cr>", desc = "close & keep window" },
  { "<leader>fbk", ":bw<Enter>", desc = "close" },
  {
    "<leader>fbl",
    '<cmd>lua require("buffer_manager.ui").load_menu_from_file()<cr>',
    desc = "buffer_manager load from file",
  },
  {
    "<leader>fbm",
    '<cmd>lua require("buffer_manager.ui").toggle_quick_menu()<cr>',
    desc = "buffer_manager open menu",
  },
  { "<leader>fbn", ":LoadBufferWithoutWindow <cr>", desc = "open file without opening a window" },
  { "<leader>fbo", ":Telescope buffers<cr>", desc = "telescope menu of all open buffers" },
  {
    "<leader>fbs",
    '<cmd>lua require("buffer_manager.ui").save_menu_to_file()<cr>',
    desc = "buffer_manager save to file",
  },
  { "<leader>fbw", ":bufdo w!<cr>", desc = "save all" },
  -- -- tabs
  { "<leader>ft", group = "tabs" },
  { "<leader>ftc", ":tabclose<cr>", desc = "close" },
  { "<leader>ftn", ":tabnew<cr>", desc = "new" },
  -- -- windows
  { "<leader>fw", group = "windows" },
  { "<leader>fwV", ":vnew", desc = "empty buffer on new vertical split" },
  { "<leader>fwX", ":new", desc = "empty buffer on new horizontal split" },
  { "<leader>fwh", "<c-w>H", desc = "move left" },
  { "<leader>fwj", "<c-w>J", desc = "move down" },
  { "<leader>fwk", "<c-w>K", desc = "move up" },
  { "<leader>fwl", "<c-w>L", desc = "move right" },
  { "<leader>fwr", "<c-w>r", desc = "rotate split window" },
  { "<leader>fwv", "<c-w>t<c-w>H", desc = "become vertical split" },
  { "<leader>fwx", "<c-w>t<c-w>K", desc = "become horizontal split" },
  -- git
  { "<leader>g", group = "git" },
  { "<leader>gb", ":BlameToggle<cr>", desc = "blame ([i]nfo, [b]ack, [f]orward)" },
  { "<leader>gd", ":Gitsigns preview_hunk<cr>", desc = "diff current hunk" },
  { "<leader>gj", ":Gitsigns next_hunk<cr>", desc = "go to next changed hunk" },
  { "<leader>gk", ":Gitsigns prev_hunk<cr>", desc = "go to previous changed hunk" },
  { "<leader>gt", ":!tmux select-window -t git<cr>", desc = "go to gitui tmux window" },
  -- BOOKMARKS
  { "<leader>k", group = "BOOKMARKS on quickfix list" },
  { "<leader>ka", "<cmd>lua require('tiagoprn.quickfix_bookmarks').add_bookmark()<cr>", desc = "Add Bookmark" },
  {
    "<leader>kx",
    "<cmd>lua require('tiagoprn.quickfix_bookmarks').delete_quickfix_item_with_telescope()<cr>",
    desc = "Remove Bookmark",
  },
  {
    "<leader>kq",
    "<cmd>lua require('tiagoprn.quickfix_bookmarks').set_current_quickfix_as_bookmarks()<cr>",
    desc = "Set current quickfix as bookmarks",
  },
  -- launchers
  { "<leader>l", group = "launchers" },
  { "<leader>lt", group = "telescope" },
  { "<leader>lta", ":Telescope builtin<cr>", desc = "all commands" },
  -- messages & notifications
  { "<leader>m", group = "messages & notifications" },
  { "<leader>mm", ":messages<cr>", desc = "show" },
  {
    "<leader>mr",
    ':lua require("tiagoprn.toggle_redir").toggle()<cr>',
    desc = "toggle redirecting messages to file - NOT real time (toggle OFF to stop and see the contents)",
  },
  -- navigation (code, hop, marks, lists etc)
  { "<leader>n", group = "navigation (code, hop, marks, lists etc)" },
  { "<leader>nC", ":lua require'aerial'.prev_up()<cr>", desc = "aerial go to previous class" },
  { "<leader>nF", ":AerialPrev<cr>", desc = "aerial go to previous function/method" },
  { "<leader>nc", ":lua require'aerial'.next_up()<cr>", desc = "aerial go to next class" },
  { "<leader>nf", ":AerialNext<cr>", desc = "aerial go to next function / method" },
  { "<leader>nl", group = "location list" },
  { "<leader>nlb", ":Telescope loclist<cr>", desc = "telescope browse" },
  { "<leader>nm", group = "marks" },
  { "<leader>nmb", ":Telescope marks<cr>", desc = "telescope browse" },
  { "<leader>nmd", ":delmarks!<cr>", desc = "delete all" },
  { "<leader>nmx", ":call MarkDelete()<cr>", desc = "delete single" },
  -- obsidian: https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#commands
  { "<leader>o", group = "Obsidian" },
  { "<leader>oa", ":ObsidianOpen<cr>", desc = "Open in Obsidian App" },
  { "<leader>ob", ":ObsidianBacklinks<cr>", desc = "Show Backlinks to this note" },
  { "<leader>oi", ":ObsidianTOC<cr>", desc = "Browse Note Section" },
  { "<leader>ol", ":ObsidianLinks<cr>", desc = "Show all links on this note" },
  { "<leader>on", ":ObsidianNew<cr>", desc = "Create New Note" },
  { "<leader>oo", group = "Open Link" },
  { "<leader>ooo", ":ObsidianFollowLink<cr>", desc = "here" },
  { "<leader>ooh", ":ObsidianFollowLink hsplit<cr>", desc = "in Horizontal Split" },
  { "<leader>oov", ":ObsidianFollowLink vsplit<cr>", desc = "in Vertical Split" },
  { "<leader>oq", ":ObsidianQuickSwitch<cr>", desc = "Quick Switch Note" },
  { "<leader>or", ":ObsidianRename<cr>", desc = "Rename Note" },
  { "<leader>os", ":ObsidianSearch<cr>", desc = "Search Inside All Notes" },
  { "<leader>ot", ":ObsidianTags<cr>", desc = "Show all tags" },
  -- plugins (lazy.nvim)
  { "<leader>p", group = "plugins (lazy.nvim)" },
  { "<leader>ps", ":Lazy sync<cr>", desc = "Update all plugins" },
  -- Python
  { "<leader>P", group = "python" },
  {
    "<leader>Pe",
    ":EmbedValueFromPythonPrintableExpression<cr>",
    desc = "type printable / evaluable python expression to embed in current buffer",
  },
  { "<leader>Pr", ":RunPythonScriptOnCurrentLine<cr>", desc = "run python script on current line" },
  -- quickfix
  { "<leader>q", group = "quickfix" },
  { "<leader>q9", ":clast<cr>", desc = "end" },
  { "<leader>ql", ":colder<cr>", desc = "older" },
  { "<leader>qn", ":cnewer<cr>", desc = "newer" },
  { "<leader>qo", ":copen<cr>", desc = "open" },
  { "<leader>qe", group = "persistance (load, save and delete from file)" },
  { "<leader>qel", "<cmd>lua require('persist-quickfix-conf').load()<cr>", desc = "load" },
  { "<leader>qes", "<cmd>lua require('persist-quickfix-conf').save()<cr>", desc = "save" },
  { "<leader>qex", "<cmd>lua require('persist-quickfix-conf').delete()<cr>", desc = "delete" },
  { "<leader>qq", ":cclose<cr>", desc = "close" },
  { "<leader>q1", ":cfirst<cr>", desc = "start" },
  { "<leader>qt", group = "telescope" },
  { "<leader>qtb", ":Telescope quickfix<cr>", desc = "telescope browse" },
  { "<leader>qth", ":Telescope quickfixhistory<cr>", desc = "telescope browse history" },
  -- redo
  { "<leader>r", ":redo<cr>", desc = "redo changes" },
  -- save current buffer
  { "<leader>s", ":w!<cr>", desc = "save current buffer" },
  -- source markdown
  { "<leader>t", ":SourceMarkdown<cr>", desc = "source markdown configuration (remove conceal, etc)" },
  -- undo changes
  { "<leader>u", ":undo<cr>", desc = "undo changes" },
  -- writing
  { "<leader>w", group = "writing" },
  { "<leader>wf", group = "fleeting notes" },
  { "<leader>wfc", ":CreateFleetingNote<cr>", desc = "create" },
  { "<leader>wfl", ":ListFleetingNotesCategories<cr>", desc = "list categories" },
  { "<leader>wfs", ":SearchFleetingNotes<cr>", desc = "search" },
  { "<leader>wfu", ":UpdateFleetingNotesCategories<cr>", desc = "update categories" },
  { "<leader>wm", group = "Mind" },
  { "<leader>wmI", ":MindOpenSmartProject<cr>", desc = "open smart project index menu" },
  {
    "<leader>wmO",
    ":MindCustomOpenDataIndexOnSmartProjectTree<cr>",
    desc = "smart project - search node and open it",
  },
  { "<leader>wmS", ":MindCustomInitializeSmartProjectTree<cr>", desc = "smart project - initialize" },
  {
    "<leader>wmY",
    ":MindCustomCopyNodeLinkIndexOnSmartProjectTree<cr>",
    desc = "smart project - search a node and copy its' link",
  },
  {
    "<leader>wmc",
    ":MindCustomCreateNodeIndexOnMainTree<cr>",
    desc = "tree - create node inside another without leaving current buffer",
  },
  { "<leader>wmi", ":MindOpenMain<cr>", desc = "open main index menu" },
  { "<leader>wmo", ":MindCustomOpenDataIndexOnMainProjectTree<cr>", desc = "tree - search node and open it" },
  { "<leader>wmq", ":MindClose<cr>", desc = "close index menu" },
  { "<leader>wmy", ":MindCustomCopyNodeLinkIndexOnMainTree<cr>", desc = "tree - search a node and copy its' link" },
  { "<leader>wn", ":OpenPersonalDoc<cr>", desc = "open note" },
  { "<leader>ws", group = "spell" },
  { "<leader>wsa", ":normal! mz[s1z=`z]<cr>", desc = "fix last misspelled word & jump back to where you were" },
  { "<leader>wsb", ":set spelllang=en,pt_br<cr>", desc = "set to EN & PT_BR" },
  { "<leader>wse", ":set spelllang=en<cr>", desc = "set to EN" },
  { "<leader>wsl", ":set spelllang?<cr>", desc = "show current language" },
  { "<leader>wso", ":set spell?<cr>", desc = "show status" },
  { "<leader>wsp", ":set spelllang=pt_br<cr>", desc = "set to PT_BR" },
  { "<leader>wst", ":set spell!<cr>", desc = "toggle" },
  { "<leader>wt", group = "Tasks" },
  { "<leader>wtc", ":CreateTask<cr>", desc = "create" },
  { "<leader>wts", ":SearchTaskCard<cr>", desc = "search" },
  { "<leader>ww", group = "writeloop" },
  { "<leader>wwf", ":CreateFlashcard<cr>", desc = "create flashcard" },
  { "<leader>wwp", ":CreatePost<cr>", desc = "create post" },
  {
    "<leader>wws",
    ":SearchWriteloop<cr>",
    desc = "search (INBOX, PERSONAL, zettels, posts, flashcards, mind-maps, etc...)",
  },
  { "<leader>wwz", ":CreateZettel<cr>", desc = "create zettel" },
  -- TODO list
  { "<leader>T", group = "TODO list" },
  { "<leader>Tf", ":TodoTelescope keywords=FIXME<cr>", desc = "telescope browse FIXMEs" },
  { "<leader>Ti", ":require('todo-comments').jump_next()<cr>", desc = "next" },
  { "<leader>Tl", ":TodoLocList<cr>", desc = "location list" },
  { "<leader>Tn", ":TodoTelescope keywords=NOTE<cr>", desc = "telescope browse NOTEs" },
  { "<leader>To", ":require('todo-comments').jump_prev()<cr>", desc = "prev" },
  { "<leader>Tq", ":TodoQuickFix<cr>", desc = "quickfix list" },
  { "<leader>Tt", ":TodoTelescope keywords=TODO<cr>", desc = "telescope browse TODOs" },
  -- toggle
  { "<leader>x", group = "toggle" },
  { "<leader>xx", ":set list!<cr>", desc = "special chars (listchars)" },
  { "<leader>xc", ":set cuc!<cr>", desc = "current column indentation" },
  { "<leader>xn", ":set number! relativenumber!<cr>", desc = "line numbers on/off" },
  { "<leader>xl", ":set cursorline!<cr>", desc = "current line" },
  { "<leader>xr", ":set rnu!<cr>", desc = "relative line numbers" },
  -- zen focus mode
  { "<leader>z", group = "zen focus mode" },
  { "<leader>zc", ":ZenCode<cr>", desc = "code full screen" },
  { "<leader>zw", ":ZenWrite<cr>", desc = "write full screen" },
  -- others
  { "<leader><C-Space>", ":bufdo w! | :q!<cr>", desc = "save all buffers and quit" },
  { "<leader><C-e>", ":e<cr>", desc = "reload file" },
  { "<leader><C-q>", ":qa!<cr>", desc = "quit without saving" },
})

-- --
-- 2) DIRECT mappings (can/must NOT be triggered with the LEADER key)
-- --
local map = vim.keymap

--> NORMAL mode
map.set("n", "<cr>", ":nohlsearch<cr>", { desc = "clean current highlighted search" })
map.set("n", "<Del>", "<C-w>c<Enter>", { desc = "close window & keep buffer" })

map.set("n", "<Up>", "<Nop>", { desc = "disable Up in normal mode" })
map.set("n", "<Down>", "<Nop>", { desc = "disable Down in normal mode" })
map.set("n", "<Left>", "<Nop>", { desc = "disable Left in normal mode" })
map.set("n", "<Right>", "<Nop>", { desc = "disable Right in normal mode" })

map.set("n", "<C-j>", ":m .+1<cr>==", { desc = "move current line/selection down" })
map.set("n", "<C-k>", ":m .-2<cr>==", { desc = "move current line/selection up" })

map.set("n", "<C-right>", ":tabnext<cr>", { desc = "go to next tab" })
map.set("n", "<C-left>", ":tabprevious<cr>", { desc = "go to previous tab" })

-- Keep the cursor in place when you join lines with J. That will also drop a mark before the operation to which you return afterwards:
map.set("n", "J", "mzJ`z", { desc = "join lines keeping cursor in place" })

map.set(
  "n",
  "<C-g>g",
  "<cmd>lua require('tiagoprn.telescope_multigrep').live_multigrep()<cr>",
  { desc = "telescope custom search using rg and optional glob filters" }
)
map.set(
  "n",
  "<C-g>o",
  ":Telescope live_grep<cr>",
  { desc = "telescope search string on current path - current window" }
)
map.set(
  "n",
  "<C-g>t",
  ":tabnew | Telescope live_grep<cr>",
  { desc = "telescope search string on current path - new tab" }
)
map.set(
  "n",
  "<C-g>s",
  ":split | Telescope live_grep<cr>",
  { desc = "telescope search string on current path - horizontal split" }
)
map.set(
  "n",
  "<C-g>v",
  ":vsplit | Telescope live_grep<cr>",
  { desc = "telescope search string on current path - vertical split" }
)
map.set(
  "n",
  "<leader>*",
  ":Telescope grep_string<cr>",
  { desc = "telescope search word/string under cursor on current path" }
)
map.set(
  "n",
  "<C-down>",
  ':lua require"tiagoprn.telescope_custom_pickers".switch_to_buffer()<cr>',
  { desc = "telescope switch to open buffer" }
)
map.set("n", "<C-up>", ":Telescope buffers<cr>", { desc = "telescope open buffer on current window" })

map.set("n", "<PageDown>", ":Gitsigns next_hunk<cr>", { desc = "gitsigns go to next hunk" })
map.set("n", "<PageUp>", ":Gitsigns prev_hunk<cr>", { desc = "gitsigns go to previous hunk" })
map.set("n", "<Home>", ":Gitsigns blame_line<cr>", { desc = "gitsigns blame line" })
map.set("n", "<End>", ":Gitsigns preview_hunk<cr>", { desc = "gitsigns preview hunk" })

map.set("n", "<leader>]", ":cn<cr>", { desc = "quickfix next item" })
map.set("n", "<leader>[", ":cp<cr>", { desc = "quickfix previous item" })

-- FUNCTION KEYS
map.set("n", "<F3>", ":NvimTreeToggle<cr>", { desc = ">>use oil instead<< nvim tree (project directory)" })
map.set(
  "n",
  "<F2>",
  "<cmd>lua require'oil'.toggle_float()<cr>",
  { desc = "(oil) toggle buffer file manager - save buffer to apply changes" }
)
map.set("n", "<F4>", ":AerialToggle<cr>", { desc = "aerial classes and methods tree" })
map.set("n", "<F5>", ":TelescopeSelectLocalClipboardFiles<cr>", { desc = "telescope select local clipboard file" })
map.set("n", "<F8>", ":Telescope bookmarks list<cr>", { desc = "telescope bookmarks list" })
map.set("n", "<F9>", ":ChatGPT<cr>", { desc = "ChatGPT prompt (<C-h> to show help menu)" })
-- map.set("n", "<F10>", ":AvanteToggle<cr>", { desc = "Toggle Avante (Anthropic Claude AI)" })
map.set("n", "<F12>", ":Markview toggle<cr>", { desc = "(markdown) turns markview on/off" })

--> VISUAL (selection) mode
map.set("v", "<", "<gv", { desc = "dedent" })
map.set("v", ">", ">gv", { desc = "indent" })

map.set("v", "<leader>ox", ":ObsidianExtractNote<cr>", { desc = "Obsidian: Extract to new note and link to it" })
map.set("v", "<leader>oe", ":ObsidianLink<cr>", { desc = "Obsidian: Create Link to existing note" })
map.set("v", "<leader>on", ":ObsidianLinkNew<cr>", { desc = "Obsidian: Create Link to new note" })

map.set("v", "<leader>y", '"+y', { desc = "YANK/COPY to system clipboard" })
map.set("v", "<leader>acr", ":FlowRunSelected<cr>", { desc = "run selection on new buffer" })

map.set("v", "<leader>aia", ":CodeCompanionActions<cr>", { desc = "CODE COMPANION - Select Action" })
map.set("v", "<leader>aip", ":CodeCompanion<cr>", { desc = "CODE COMPANION - Run prompt on selection" })

--> INSERT mode
map.set("i", "<C-right>", "<Esc>:tabnext<cr>", { desc = "go to next tab" })
map.set("i", "<C-left>", "<Esc>:tabprevious<cr>", { desc = "go to previous tab" })

-- --
-- 3) DYNAMIC (programatic) MAPPINGS
--   references: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f#file-mappings-lua
-- --
-- Easier window switching with leader + Number
-- Creates mappings like this: km.set("n", "<Leader>2", "2<C-W>w", { desc = "Move to Window 2" })
for i = 1, 6 do
  local lhs = "<Leader>" .. i
  local rhs = i .. "<C-W>w"
  map.set("n", lhs, rhs, { desc = "Go to Window " .. i })
end
