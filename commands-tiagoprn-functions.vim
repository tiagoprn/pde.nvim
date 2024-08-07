command! SearchWriteloop lua require'tiagoprn.special_dirs'.searchWriteloop()
command! SearchFleetingNotes lua require'tiagoprn.special_dirs'.searchFleetingNotes()
command! SearchTaskCard lua require'tiagoprn.special_dirs'.searchTaskCard()
command! OpenPersonalDoc lua require'tiagoprn.special_dirs'.openPersonalDoc()
command! CreateFleetingNote lua require'tiagoprn.scratchpad'.createFleetingNote()
command! CreateTask lua require'tiagoprn.scratchpad'.createTask()
command! CreateFlashcard lua require'tiagoprn.scratchpad'.createFlashCard()
command! CreatePost lua require'tiagoprn.scratchpad'.createPost()
command! CreateZettel lua require'tiagoprn.scratchpad'.createZettel()
command! ZenCode lua require'tiagoprn.scratchpad'.zenCode()
command! ZenWrite lua require'tiagoprn.scratchpad'.zenWrite()
command! EmbedValueFromPythonPrintableExpression lua require'tiagoprn.scratchpad'.embed_value_from_python_printable_expression()
command! RunPythonScriptOnCurrentLine lua require'tiagoprn.scratchpad'.run_python_script_on_current_line()
command! DeleteSpacesFromMarkdownMetadata lua require'tiagoprn.scratchpad'.deleteSpacesFromMarkdownMetadata()
command! ListFleetingNotesCategories execute "!rg '^- [A-Z]+:' /storage/docs/fleeting-notes | awk  '{print $2}' | sort | uniq | column -c 80"
command! UpdateFleetingNotesCategories execute "!/storage/src/dot_files/tiling-window-managers/scripts/update-fleeting-notes-categories.sh"


command! GetCurrentFileAbsolutePositionAndCopyToClipboard lua require"tiagoprn.scratchpad".get_current_file_position_and_copy_to_clipboard({kind="absolute"})
command! GetCurrentFileRelativePositionAndCopyToClipboard lua require"tiagoprn.scratchpad".get_current_file_position_and_copy_to_clipboard({kind="relative"})
command! GetCurrentFilenamePositionAndCopyToClipboard lua require"tiagoprn.scratchpad".get_current_file_position_and_copy_to_clipboard({kind="only_name"})

command! RunCommandOnTmuxScratchpadSession lua require"tiagoprn.scratchpad".run_command_on_tmux_scratchpad_session()
command! RerunLastCommandOnTmuxScratchpadSession lua require"tiagoprn.scratchpad".rerun_last_command_on_tmux_scratchpad_session()

command! RunInteractiveCommandOnCurrentFunctionOrMethodAtTmuxScratchpadSession lua require"tiagoprn.code_utils".run_interactive_command_on_current_function_or_method_at_tmux_scratchpad_session()
command! RunSelectPythonClass lua require"tiagoprn.code_utils".select_python_class()
command! RunPytestOnCurrentFunctionOrMethodAtTmuxScratchpadSession lua require"tiagoprn.code_utils".run_pytest_on_current_function_or_method_at_tmux_scratchpad_session()
command! PrintLspSupportedRequests lua require"tiagoprn.code_utils".print_lsp_supported_requests()

command! MindCustomCreateNodeIndexOnMainTree lua require'tiagoprn.mind'.mind_custom_create_node_index_on_main_tree()
command! MindCustomInitializeSmartProjectTree lua require'tiagoprn.mind'.mind_custom_initialize_smart_project_tree()
command! MindCustomCopyNodeLinkIndexOnSmartProjectTree lua require'tiagoprn.mind'.mind_custom_copy_node_link_index_on_smart_project_tree()
command! MindCustomCopyNodeLinkIndexOnMainTree lua require'tiagoprn.mind'.mind_custom_copy_node_link_index_on_main_tree()
command! MindCustomOpenDataIndexOnSmartProjectTree lua require'tiagoprn.mind'.mind_custom_open_data_index_on_smart_project_tree()
command! MindCustomOpenDataIndexOnMainProjectTree lua require'tiagoprn.mind'.mind_custom_open_data_index_on_main_project_tree()

command! SearchOnOpenFiles lua require'tiagoprn.telescope_custom_pickers'.search_on_open_files()
command! PythonProjectSearch lua require'tiagoprn.telescope_custom_pickers'.python_project_search()
command! GeneratePythonProjectDefinitionsFile lua require'tiagoprn.telescope_custom_pickers'.generate_python_project_definitions_file()
command! LoadBufferWithoutWindow lua require'tiagoprn.telescope_custom_pickers'.load_buffer_without_window()

command! SourceMarkdown lua require'tiagoprn.helpers'.source_markdown()
