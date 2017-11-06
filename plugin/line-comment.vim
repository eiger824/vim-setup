function! ToggleLineComment()
	" Get current line
	let line = getline('.')
	" Check if line starts with //
	if line[0:1] == "//"
		let save_cursor = getcurpos()
		let oldcol = save_cursor[2]
		let save_cursor[2] = oldcol - 2
		execute "normal! 0xxi"
		call setpos('.', save_cursor)
	else
		let save_cursor = getcurpos()
		let oldcol = save_cursor[2]
		let save_cursor[2] = oldcol + 2
		execute "normal! 0i//"
		call setpos('.', save_cursor)
	endif
endfunction
