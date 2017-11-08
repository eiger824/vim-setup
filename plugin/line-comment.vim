function! GetFileExtension()
	let current_filename = expand("%")
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" Check for file format, since comment mark will depend
	" on that
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let format = split(current_filename, '\.')[-1]
	if format == "c" || format == "h" ||
				\ format == "cpp" || format == "hpp" || format == "cc" || format == "cxx" ||
				\ format == "tpp" ||
				\ format == "java" ||
				\ format == "dts"
		return "// "
	elseif format == "sh" || format == "bash"
		return "#  "
	elseif format == "vim" || format == "vimrc"
		return '"  '
	elseif format == "bashrc" || format == "bash_aliases"
		return "#  "
	endif
endfunction

function! ToggleLineComment()
	" Get current line
	let current_filename = expand("%")
	let line = getline('.')
	let pattern = GetFileExtension()
	" Check if line starts with pattern: recommended format
	if line[0:1] == pattern
		let save_cursor = getcurpos()
		let oldcol = save_cursor[2]
		let save_cursor[2] = oldcol - 3
		execute "normal! 0xxxi"
		call setpos('.', save_cursor)
	else
		" Either no comment mark or line does not start
		" where it should with the comment marks
		let line_length = len(line)
		let index = 0
		while index < line_length - 2
			if line[index:index+2] == pattern
				execute "normal! 0" . string(index) . "lxxx"
				return
			endif
			let index += 1
		endwhile
		let save_cursor = getcurpos()
		let oldcol = save_cursor[2]
		let save_cursor[2] = oldcol + 3
		execute "normal! 0i" . pattern
		call setpos('.', save_cursor)
	endif
endfunction

function! ToggleBlockLineComment()
	let save_cursor = getcurpos()
	let oldcol = save_cursor[2]
	let save_cursor[2] = oldcol + 6
	let open_pattern = GetFileExtension()
	" Check if C/C++/Java/DTS file for /**/ type comments
	if open_pattern == "// "
		let open_pattern = "/* "
	endif
	let close_pattern = join(reverse(split(open_pattern, '\zs')), '')
	" Get current line
	let line = getline('.')
	" Check if line starts with //
	if line[0:2] == open_pattern
		execute "normal! 0xxxi"
		execute "normal! $xxxi"
		call setpos('.', save_cursor)
	else
		" Either no comment mark or line does not start where it should with
		" the comment marks
		let line_length = len(line)
		let index = 0
		let found = 0
		while index < line_length - 2
			if line[index:index+2] == open_pattern
				execute "normal! 0" . string(index) . "lxxx"
				let found = 1
			elseif line[index:index+2] == close_pattern
				execute "normal! 0" . string(index) . "lxxx"
				let found = 1
			endif
			let index += 1
		endwhile
		if found == 0
			execute "normal! 0i" . open_pattern
			execute "normal! A" . close_pattern
		endif
		call setpos('.', save_cursor)
	endif
endfunction


function! ToggleBlockLineCommentRuntime()
	let open_pattern = GetFileExtension()
	if open_pattern == "// "
		let open_pattern = "/* "
	endif
	let close_pattern = join(reverse(split(open_pattern, '\zs')), '')
	call setline(line('.'), getline('.') . " " . open_pattern . close_pattern)
endfunction
