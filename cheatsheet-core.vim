"" repetitions

" .| " repeat the last command
" 5p| " paste text 5 times
" 3yy| " copy current line and the 2 ones below it
" 2f [char]| " go to the second occurence of char in line
" 10k| " moves 10 lines up
" 5j| " move 5 lines down


"" movement

" h  | "  (movement)   left
" j  | "  (movement)   down
" k  | "  (movement)   up
" l  | "  (movement)   right
" gj | "  (movement)   move down on soft wrapped line
" gk | "  (movement)   move up on soft wrapped line
" w  | "  (movement)   next word
" )  | "  (movement)   next sentence
" }  | "  (movement)   next paragraph
" b  | "  (movement)   beginning of current word / previous word
" ge | "  (movement)   end of the previous word
" gM | "  (movement)   middle of the current line
" e  | "  (movement)   end of current word / end of next word
" ^  | "  (movement)   first non-blank character of a line
" f [char]  | "  (movement)   go to specific char in line, ';' to go to the next occurrence of it
" t [char]  | "  (movement)   go to one character previous/before specific char in line, ';' to go to the next occurrence of it
" H  | " (movement) high on the viewport
" M  | " (movement) middle on the viewport
" L  | " (movement) low on the viewport
" zz  | "  (movement)   without moving the cursor, put the current line on the middle of the screen (viewport).
" zt  | "  (movement)   without moving the cursor, put the current line on the top of the screen (viewport).
" zb  | "  (movement)   without moving the cursor, put the current line on the bottom of the screen (viewport).
" g; | " go to the previous place you were editing on the current file
" gi | " go to the previous place you were editing on the current file and automatically change to INSERT MODE
" ctrl+e | " (movement) move one line down on viewport
" ctrl+y | " (movement) move one line up on viewport
" ctrl+h | " (movement) move current character left
" ctrl+l | " (movement) move current character right
" ctrl+n | " (movement) on popup menus, move to next
" ctrl+p | " (movement) on popup menus, move to previous


"" cut and paste

" 20co  | " (cut-paste) Your cursor is on line 10. You want to paste line 20 to one line below your current cursor position.
" 20,25co10 | " (cut-paste) your cursor is on line 10. You want to paste text from line 20 to 25 under line 10.
" -10t | " (cut-paste) paste the line, which is 10 lines above your current line, to a line below your current position ("t" is an abbreviation of "co"[py] command)


"" others

" (INSERT) <ctrl>[ | " alternate way to go to VISUAL mode instead of ESC
" (INSERT ) <ctrl+o> | " go to normal mode to execute just one command and go back to insert mode
" 80i*<esc> | "  (in visual mode - do not start with ':' - this will insert the * character 80 times on the current cursor position)
" 3i`<esc> | "  (in visual mode - do not start with ':' - this will insert the backstick character 3 times on the current cursor position)
" o | "  insert blank line below cursor
" O | "  insert blank line above cursor
" A | "  go to end of line and enter insert mode
" I | "  go to beginning of line and enter insert mode
" C | "  Delete until end of the line and enter insert mode
" D | "  Delete until end of the line
" vg_ | "  Delete until end of the line (does NOT include \n)
" :%s/ /\r/g | " replace spaces for <enter>
" :%s/old/new/gc | " replace asking for confirmation on each occurence
" :%s/https.*/[&]()/g | " (replace) find all urls/links with regex and replace them with markdown syntax - the '&' does the magic and inserts the matched text
" shift+v  | "  select a whole line
" :w !sudo tee % | " save file as sudo when you forgot to do that
" :set et|retab | " replaces tab with 4 spaces
" zR | " open all folds
" zM | " close all folds
" zo | " open current fold
" zc | " close current fold
" za | " toggle current fold
" zd | " delete current fold
" "<register-name><command> | " (registers)       syntax format
" [ " ] | " (registers)    default/unnamed : updates whenever you delete or yank
" [ - ] | " (registers)    small delete: deleted text smaller than one line
" [ 0..9 ] | " (registers)    numbered: 0 - latest yank or big delete (greater than one line), 1..9 - big deletes or changes
" [ a..z ] | " (registers)    named: changing value replaces register contents (those are also used for the macros!)
" [ A..Z ] | " (registers)    named: changing value appends to register
" [ _ ] | " (registers)    black hole
" [ / ] | " (registers)    last search pattern
" "+yy | " (registers) copy current line to system clipboard (change + for * to primary 'mouse " selection' clipboard)
" "+veey | " (registers) copy next 2 words to system clipboard
" "+p | " (registers) paste system clipboard contents
" "ayy | " (registers) copy current line to register a
" "Ayy | " (registers) append current line to register a (use a capital letter to append to a register)
" "ap | " (registers) paste register a contents
" :let @z = "value" | " (registers) set register 'z' value
" :let @z = "" | " (registers) clean register 'z' value
" :let @x = @z | " (registers) set register 'x' values as register 'z' value
" :reg | " (registers) see all registers' contents
" <C-r>register-name | " (registers) paste from register on insert or command mode.
" :verbose map | " (mapping) show all defined mappings in vim - and where the mappings are defined
" :map | " (mapping) show all defined mappings in vim (non-verbose, simple list)
" :vmap <key> | " (mapping) show if <key> is mapped
" :cdo[!] {cmd} | update | " (quickfix) Execute {cmd} in EACH VALID ENTRY in the quickfix list and save all files
" :cfdo[!] {cmd} | update | " (quickfix) Execute {cmd} in EACH FILE in the quickfix list and save all files. E.g. :cfdo[!] %s/old/new/g | update
" :chistory | " (quickfix) show your quickfix lists
" :ld[o][!] {cmd} | " (location-list) Execute {cmd} in each valid entry in the location list for the current window.
" :lfdo[!] {cmd} | " (location-list) Execute {cmd} in each file in the location list for the current window.
" :lhistory | " (location-list) show your location lists
" (NORMAL) gf | " open text file/directory under cursor (works 'magically' if there is a file/directory under the current cursor)
" (NORMAL) <C-W>f | " open text file/directory under cursor  - like gf, but on a split (works 'magically' if there is a file/directory under the current cursor)
" :gF | " open text file/directory under cursor on the line (works 'magically' if there is a file/directory under the current cursor. E.g. `file.py:75`)
" :gx | " open file/directory under cursor with the corresponding application (xdg-open like)
" Vjjjj :normal @a | " (macros) run macro 'a' on selected lines
" ]s | " (spellcheck) jump to the next misspelled word
" [s | " (spellcheck) jump to the previous misspelled word
" z= | " (spellcheck) bring up the suggested replacements
" zg | " (spellcheck) add the word under the cursor to the dictionary
" zw | " (spellcheck) undo and remove the word from the dictionary
" zug | " (spellcheck) remove last word added to the dictionary
" :args /full/path/**/*.txt | " (global search/replace) 01 - populate args list with a list of files (recursively)
" :argdo %s/old/new/g | " (global search/replace) 02 - replace on all files on the args list
" :argdo update | " (global search/replace) 03 - save all files on the args list
" :wn | " (global search/replace) 04 - save current file and move to the next one in the args list
" :read !<command> | " run external command and insert its' stdout on current position
" (SELECTION) :write !<command> | " run external command (e.g. python, etc...) with selection as input.
" (SELECTION) :!<command> | " run external command on selected text. e.g. figlet, column, sort, etc...
" :m' | " (jumps/marks) mark current line (so that it appears on the jump list)
" :ju | " (jumps) show jumps list (the current position has a '>' on the list)
" <ctrl-o> | " (jumps) go to previous jump on jumps list
" <ctrl-i> | " (jumps) go to next jump on jumps list
" :clearjumps | " (jumps) clear the jumps list
" :windo w! | " (windows) save files open on all windows
" :windo e! | " (windows) reload files open on all windows
" (NORMAL) :split | " (windows) split horizontally (below)
" (NORMAL) :vsplit | " (windows) split vertically (aside)
" (NORMAL) :only | " (windows) close other windows, keeping just current window opened
" <ctrl-]> | " (help) jump to tag under cursor - you can use (jumps) navigation mappings to navigate back and forth between them.
" :g/[word_or_regex]/d | "  (global-commands)(patterns) delete lines matching word or regex
" :g!/[word_or_regex]/d | " (global-commands)(patterns) delete lines that do NOT match the word or regex
" :g/^\s*$/d | " (global-commands)(patterns) delete all blank lines
" :g/^$/d | " (global-commands)(patterns) delete blank lines from selection
" :g/[word_or_regex]/m$ | " (global-commands)(patterns) Move all lines containing word or regex to the end of the file
" :g/[word_or_regex]/norm $[normal_command] | " (global-commands)(patterns) for all lines containing '[word_or_regex]', execute the normal command [normal_command]. E.g.: ':g/    highlight/normal! 0C    highlight = {colors.violet,colors.white}'
" :g/if/norm $a: | " (global-commands)(patterns) for all lines containing 'if', execute the normal command to append a ':' to the end of a line.
" (NORMAL) d/word | " (global-commands)(patterns) delete on line until word
" <ctrl-a> | " (numbers) increment the next number on the line
" <ctrl-x> | " (numbers) decrement the next number on the line
" (VISUAL)gv | " re-select/redo last visual selection
" >> or 3>> | " (NORMAL) indent (one line or e.g. 3 lines)
" << or 3<< | " (NORMAL) deindent (one line or e.g. 3 lines)
" :lua require'sample'.runExternalCommand() | " (VISUAL) run lua runExternalCommand sample function
" :lua require'sample'.checkForErrorsAsBooleanVariable() | " (VISUAL) run lua checkForErrorsAsBooleanVariable sample function
" :lua require'sample'.welcomeToLua() | " (VISUAL) run lua welcomeToLua sample function
" <C-v>, I or c | " (multiple cursors) <C-v> to select a block, <I> to insert on all lines or <c> to replace text on the block. Pressing <ESC> stops and shows change on all lines.
" Note | " (tabs) IMPORTANT: tabs are not buffers and are easier to grasp than they are. You can also use "tabdo" to operate commands on all current tabs.
" Note | " (global-commands) IMPORTANT: global commands are the commands "g/". For more info: ':help global'.
" Note | " (global-commands) IMPORTANT: the general syntax of global commands is: ':[range]g[lobal]/{pattern}/[cmd]'
" :help nvim-from-vim | " help page on what is different from vim
" :messages | " show session history messages
" :messages clear | " clear all session history messages
" :grep 'text' | " do a search with rg and populate the quickfix with it
" :set ft? | " show the filetype of the current file
" x,y copy z  | " copy lines x to y to after line z
" :mks [path-to-session-file]  | " (sessions) creates a new nvim session
" :mks!  | " (sessions) updates the current nvim session with the opened buffers
" :source [path-to-session-file] | " (sessions) open buffers from the session file
" nvim -S [path-to-session-file] | " (sessions) open nvim with the buffers from the session file
" (INSERT MODE)<ctrl-k> <digraph_code>  | " (special chars/digraphs) insert a special char / digraph (ex.: subscript, superscript, TM symbol, etc...)
" :digraph  | " (special chars/digraphs) show a table of special chars / digraphs to use on INSERT MODE (ex.: subscript, superscript, TM symbol, etc...)
" :checkhealth | " (core,diagnostics) nvim health
" :luafile % | " (core) reload current open lua plugin config file - use after lua config file changes (e.g. lualine-conf.lua)
" ~ |" invert case
" U |" change to uppercase
" u |" change to lowercase
" (VISUAL)!sort  | " run bash/shell command sort on all selected lines
" (VISUAL)!ls -la  | " run bash/shell command ls and insert its stdout into the current buffer
" (VISUAL) :bufdo bdelete | " close all current buffers
" (VISUAL) :5,50d | " delete an interval of lines
" (VISUAL) :.,+100000d | "  delete the next 100k lines (from the current line)
" (VISUAL) d$ | " delete until end of line:
" (VISUAL) d0 | " delete until beginning of line
" (VISUAL) * | " search current word under cursor forwards (repeat key to go to the next ocurrences)
" (VISUAL) # | " search current word under cursor backwards (repeat key to go to the next ocurrences)
" (VISUAL) :%s/search/replace/g[ic] | " (search/replace) g: all ocurrences in the line, i: case insensitive, c: confirm each match
" (VISUAL) q: | " List of past commands (hitting <shift+v><enter> you can execute them)
":h events | " help on the events available on nvim, its' buffers, etc...
" (VISUAL) ]] | " markdown file - go to next header/section
" (VISUAL) [[ | " markdown file - go to previous header/section
" :autocmd BufWritePre | " (debug/inspect/troubleshooting) see all (auto)commands related to this write event. Related events: BufWritePost, BufWriteCmd.
" :h events | " (debug/inspect/troubleshooting) list all events possible on a buffer.
" <C-w>, <Shift-t> | " ( windows ) splits - open split in new tab (this destroys the split in the original window)
" (SELECTION) :g/apples/y A | " search and copy/yank lines matching pattern 'apples' (you can use e.g. a regex also) and store them on the "a" register
" (SELECTION) :g/apples/y A | " NOTE: search and copy/yank lines: if a CAPITAL LETTER is used as the yank register, MATCHES WILL BE APPENDED to that register.
" (SELECTION) :g/apples/y a | " NOTE: search and copy/yank lines: if a LOWERCASE LETTER is used, only the LAST MATCH WILL BE PLACED in that register.
" "ap | " search and copy/yank lines: paste lines from register a used to store the search matching pattern
