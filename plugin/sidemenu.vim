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
	\       ['gb', 'Denite dein', 'Plugins list'],
	\       ['gc', 'Denite session -buffer-name=list', 'Load session'],
	\       ['gd', 'Denite session:new', 'Save session…'],
	\       ['ge', 'Denite z', 'Z (jump around)'],
	\       ['gf', 'Denite command_history', 'Command history'],
	\       ['gg', 'Denite help', 'Vim help'],
	\   ]},
	\   { 'title': 'Project',
	\     'children': [
	\       ['po', 'Vista', 'Tag outline'],
	\       ['ps', 'Denite gitstatus -no-start-filter', 'Git status'],
	\       ['pm', 'SignatureListGlobalMarks', 'Bookmarks'],
	\       ['pu', 'UndotreeToggle', 'Undo tree'],
	\   ]},
	\   { 'title': 'Files',
	\     'children': [
	\       ['fe', 'Defx -buffer-name=temp -split=vertical', 'File explorer'],
	\       ['fg', 'Denite grep -no-start-filter', 'Find in files…'],
	\       ['ff', 'Denite file/rec', 'Find files'],
	\       ['fb', 'Denite buffer -default-action=switch', 'Buffers'],
	\       ['fo', 'Denite file/old', 'Most Recent'],
	\   ]},
	\   { 'title': 'Tools',
	\     'children': [
	\       ['a', 'Denite gitlog:all -no-start-filter', 'Git log'],
	\       ['b', 'Denite gitstatus -no-start-filter', 'Git status'],
	\       ['c', 'Denite gitchanged:', 'Git changed'],
	\       ['d', 'Neomake', 'Check syntax'],
	\       ['e', 'Goyo', 'Distraction-free'],
	\       ['f', 'Thesaurus', 'Thesaurus'],
	\       ['g', 'XtermColorTable', 'Xterm color-table'],
	\       ['h', 'ColorSwatchGenerate', 'Syntax color swatch'],
	\       ['i', 'Vinarise', 'Hex editor'],
	\       ['j', 'Codi python', 'Codi (python)'],
	\   ]},
	\   { 'title': 'System',
	\     'children': [
	\       ['1', 'checkhealth', 'Check health'],
	\       ['2', 'echo dein#get_updates_log()', 'View updates log'],
	\       ['3', 'echo dein#get_log()', 'View dein log'],
	\   ]},
	\ ]

" vim: set ts=2 sw=2 tw=80 noet :
