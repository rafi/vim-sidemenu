" Sidemenu.vim
" The MIT License (MIT)
"
" Maintainer: Rafael Bodill https://github.com/rafi/vim-sidemenu
" Based on: Junegunn Choi https://github.com/junegunn/vim-peekaboo

nnoremap <silent> <Plug>(sidemenu) :<C-u>call sidemenu#open(0)<cr>
xnoremap <silent> <Plug>(sidemenu-visual) :<C-u>call sidemenu#open(1)<cr>

let g:sidemenu = [
	\   { 'title': 'General & Plugins',
	\     'children': [
	\       ['ga', 'call dein#update()', 'Plugins update', 'Update all plugins'],
	\       ['gb', 'lua require"plugins.telescope".pickers.plugin_directories()', 'Plugins list'],
	\       ['gc', 'Telescope session-lens search_session', 'Load session'],
	\       ['gd', 'Telescope search_history', 'Search history'],
	\       ['gf', 'Telescope command_history', 'Command history'],
	\       ['gg', 'Telescope help_tags', 'Vim help'],
	\   ]},
	\   { 'title': 'Project',
	\     'children': [
	\       ['po', 'SymbolsOutline', 'Symbols outline'],
	\       ['ps', 'Gina status -s', 'Git status'],
	\       ['pm', 'SignatureListGlobalMarks', 'Bookmarks'],
	\       ['pu', 'UndotreeToggle', 'Undo tree'],
	\   ]},
	\   { 'title': 'Files',
	\     'children': [
	\       ['fe', 'Fern -toggle -drawer .', 'File explorer'],
	\       ['fg', 'Telescope live_grep', 'Find in files…'],
	\       ['ff', 'Telescope find_files', 'Find files'],
	\       ['fb', 'Telescope buffers', 'Buffers'],
	\       ['fo', 'Telescope oldfiles', 'Most Recent'],
	\   ]},
	\   { 'title': 'Tools',
	\     'children': [
	\       ['a', 'Neogit', 'Neogit'],
	\       ['b', 'DiffviewOpen', 'Diffview'],
	\       ['c', 'Gina log --graph --all', 'Git log'],
	\       ['d', 'Gina status -s', 'Git status'],
	\       ['e', 'Gina changes', 'Git changed'],
	\       ['f', 'lua vim.lsp.diagnostic.set_loclist()', 'Diagnostics'],
	\       ['g', 'Telescope registers', 'Paste from registers…'],
	\       ['h', 'ZenMode', 'Distraction-free'],
	\       ['i', 'ThesaurusQueryReplaceCurrentWord', 'Thesaurus query word…'],
	\   ]},
	\   { 'title': 'System',
	\     'children': [
	\       ['1', 'checkhealth', 'Check health'],
	\       ['2', 'echo dein#get_updates_log()', 'View updates log'],
	\       ['3', 'echo dein#get_log()', 'View dein log'],
	\   ]},
	\ ]

" vim: set ts=2 sw=2 tw=80 noet :
