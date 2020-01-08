" Sidemenu.vim
" The MIT License (MIT)
"
" Maintainer: Rafael Bodill https://github.com/rafi/vim-sidemenu
" Based on: Junegunn Choi https://github.com/junegunn/vim-peekaboo

let s:cpo_save = &cpoptions
set cpoptions&vim

" Private variables
" ---
let s:RETURN = 13
let s:ESCAPE = 27

let s:items = {}
let s:buf_sidemenu = 0
let s:scroll = {
	\ "\<up>":     "\<c-y>", "\<down>":     "\<c-e>",
	\ "\<c-y>":    "\<c-y>", "\<c-e>":      "\<c-e>",
	\ "\<c-u>":    "\<c-u>", "\<c-d>":      "\<c-d>",
	\ "\<c-b>":    "\<c-b>", "\<c-f>":      "\<c-f>",
	\ "\<pageup>": "\<c-b>", "\<pagedown>": "\<c-f>"
	\ }

" Default options
let s:default_window = 'vertical botright 30new'
let s:default_compact = 0
let s:default_open_immediately = 0
let s:default_verbosity = 1

" Public function
" ---

" Open sidemenu
function! sidemenu#open(visualmode) abort
	if s:is_open()
		call s:close()
	endif

	let verbose = get(g:, 'sidemenu_verbosity', s:default_verbosity)
	let open_immediately =
		\ get(g:, 'sidemenu_open_immediately', s:default_open_immediately)

	let positions = { 'current': s:getpos() }
	call s:open()
	let positions.sidemenu = s:getpos()

	let inplace = positions.current.tab == positions.sidemenu.tab &&
		\ positions.current.win == positions.sidemenu.win
	let visible = ! inplace && s:is_visible(positions.current)

	call s:gv(a:visualmode, visible)

	let [stl, lst] = [&showtabline, &laststatus]
	let zoom = 0
	let keys = []
	try
		" Start event-loop to capture keystrokes
		while 1
			let char = getchar()
			let key = tolower(nr2char(char))
			let scroll_key = get(s:scroll, char, get(s:scroll, key, ''))

			" Has user pressed <CR> or <Esc>?
			if char == s:RETURN || char == s:ESCAPE
				if zoom
					tab close
				endif
				break

			" Is user scrolling window?
			elseif ! empty(scroll_key)
				execute 'normal!' scroll_key
				call s:gv(a:visualmode, visible)

			" Is user trying to zoom with <Space>?
			elseif key ==# ' '
				if zoom
					tab close
					let [&showtabline, &laststatus] = [stl, lst]
					call s:gv(a:visualmode, visible)
				else
					tab split
					set showtabline=0 laststatus=0
				endif
				let zoom = ! zoom
				redraw
			else
				" Let's look for matches...
				let command = join(keys, '') . key
				let match = 0
				for [item_key, item_value] in items(s:items)
					if stridx(item_key, command) == 0
						let match = match + 1
					endif
				endfor

				if match == 0
					" No match found. Use the last key that was pressed, but reset keys
					" all previous keys from stack. Intentionally disabling ability to
					" immediately run a wrong command.
					let keys = []
					let command = key
					setlocal nocursorline
				endif

				call add(keys, key)

				if match == 1 && open_immediately
					break
				endif

				syntax clear sidemenuSelected
				execute 'syntax match sidemenuSelected "\v^ '.command.'"'
					\ .' contained contains=sidemenuSelectedSpace'

				if has_key(s:items, command)
					" There is a candidate for an exact match
					let line = s:items[command][0]
					execute line
					setlocal cursorline
				endif
				call s:gv(a:visualmode, visible)

				if verbose && match == 1
					echo join(s:items[command][3:], ': ')
				endif
			endif
		endwhile

		" - Make sure that we're back to the original tab/window/buffer
		"   - e.g. g:sidemenu_window = 'tabnew' / 'enew'
		if inplace
			noautocmd execute positions.current.win.'wincmd w'
			noautocmd execute 'buf' positions.current.buf
		else
			noautocmd execute 'tabnext' positions.current.tab
			call s:close()
			noautocmd execute positions.current.win.'wincmd w'
		endif
		if a:visualmode
			normal! gv
		endif
	catch /^Vim:Interrupt$/
		return
	finally
		let [&showtabline, &laststatus] = [stl, lst]
		call s:close()
		redraw
	endtry

	if char == s:RETURN || (open_immediately && char != s:ESCAPE)
		if len(keys) > 0
			let exe = s:items[join(keys, '')][2]
			if verbose | echomsg 'Executing: ' exe | endif
			execute exe
		endif
	endif
endfunction

" Private functions
" ---

" Checks if sidemenu buffer is open
function! s:is_open() abort
	return s:buf_sidemenu
endfunction

" Appends macro list for the specified group to sidemenu window
function! s:append_group(title, items) abort
	let compact = get(g:, 'sidemenu_compact', s:default_compact)
	if ! compact | call append(line('$'), a:title.':') | endif
	for r in a:items
		try
			if empty(r[0])
				continue
			endif
			let s:items[printf('%s', r[0])] = [line('$')] + r
			call append(line('$'), printf(' %s: %s', r[0], r[2]))
		catch
		endtry
	endfor
	if ! compact | call append(line('$'), '') | endif
endfunction

" Closes sidemenu buffer
function! s:close() abort
	silent! execute 'bd' s:buf_sidemenu
	let s:buf_sidemenu = 0
	execute s:winrestcmd
endfunction

" Opens sidemenu window
function! s:open() abort
	let s:winrestcmd = winrestcmd()
	execute get(g:, 'sidemenu_window', s:default_window)
	let s:buf_sidemenu = bufnr('')
	setlocal nonumber buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
		\ modifiable statusline=>\ Main-menu nocursorline nofoldenable
	if exists('&relativenumber')
		setlocal norelativenumber
	endif

	setfiletype sidemenu

	syntax clear
	syntax match sidemenuTitle /^[A-Za-z-_ &()#!]*/ contained
	syntax match sidemenuTitleColon /^[A-Za-z-_ &()#!]*:/ contains=sidemenuTitle
	syntax match sidemenuReg /^ [^: ]\{1,3}/ contained contains=sidemenuSelected
	syntax match sidemenuRegColon /^ [^: ]\{1,3}:/ contains=sidemenuReg
	syntax match sidemenuSelectedSpace /^ / contained
	highlight default link sidemenuTitle Title
	highlight default link sidemenuTitleColon NonText
	highlight default link sidemenuReg Label
	highlight default link sidemenuRegColon NonText
	highlight default link sidemenuSelected SpellRare

	augroup sidemenu
		autocmd!
		autocmd CursorMoved <buffer> bd
	augroup END

	let s:items = {}
	for group in g:sidemenu
		call s:append_group(group['title'], group['children'])
	endfor
	silent! normal! "_dd
endfunction

" Checks if the buffer for the position is visible on screen
function! s:is_visible(pos) abort
	return a:pos.tab == tabpagenr() && bufwinnr(a:pos.buf) != -1
endfunction

" Triggers gv to keep visual highlight on
function! s:gv(visualmode, visible) abort
	if a:visualmode && a:visible
		wincmd p
		normal! gv
		redraw
		wincmd p
	else
		redraw
	endif
endfunction

" Returns the position of the current buffer as a dictionary
function! s:getpos() abort
	return {'tab': tabpagenr(), 'buf': bufnr(''), 'win': winnr(), 'cnt': winnr('$')}
endfunction

let &cpoptions = s:cpo_save
unlet s:cpo_save

" vim: set ts=2 sw=2 tw=80 noet :
