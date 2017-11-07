function! ToggleLineComment()
	" Get current line
	let line = getline('.')
	" Check if line starts with //: recommended format 
	if line[0:1] == "//"
		let save_cursor = getcurpos()
		let oldcol = save_cursor[2]
		let save_cursor[2] = oldcol - 2
		execute "normal! 0xxi"
		call setpos('.', save_cursor)
	else
		" Either no comment mark or line does not start
		" where it should with the comment marks
		let line_length = len(line)
		let index = 0
		while index < line_length - 1
			if line[index:index+1] == "//"
				execute "normal! 0" . string(index) . "lxx" 
				return
			endif
			let index += 1
		endwhile
		let save_cursor = getcurpos()
		let oldcol = save_cursor[2]
		let save_cursor[2] = oldcol + 2
		execute "normal! 0i//"
		call setpos('.', save_cursor)
	endif
endfunction

function! ToggleBlockLineComment()
	let save_cursor = getcurpos()
	let oldcol = save_cursor[2]
	let save_cursor[2] = oldcol + 4
	" Get current line
	let line = getline('.')
	" Check if line starts with //
	if line[0:1] == "/*"
		execute "normal! 0xxi"
		execute "normal! $xxi"
		call setpos('.', save_cursor)
	else
		" Either no comment mark or line does not start where it should with
		" the comment marks
		let line_length = len(line)
		let index = 0
		let found = 0
		while index < line_length - 1
			if line[index:index+1] == "/*"
				execute "normal! 0" . string(index) . "lxx" 
				let found = 1
			elseif line[index:index+1] == "*/"
				execute "normal! 0" . string(index) . "lxx"
				let found = 1
			endif
			let index += 1
		endwhile
		if found == 0
			execute "normal! 0i/*"
			execute "normal! A*/"
		endif
		call setpos('.', save_cursor)
	endif
endfunction
