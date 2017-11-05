function! BlockComment(line1, line2)
	"Get first line from line number line1
	let prev_line = a:line1 - 1
	call append(prev_line, "/*")

	let second_line = getline(a:line2 + 1)
	call append(a:line2, "*/")
endfunction

function! BlockCommentInteractive()
	"Get first line from line number line1
	call inputsave()
	let line1 = input('Starting line?: ')
	let prev_line = line1 - 1
	call append(prev_line, "/*")

	let second_line = input('End line?: ')
	call inputrestore()
	call append(second_line + 1, "*/")
endfunction

function! BlockUncomment()
	let init_line = line('^')
	let last_line = line('$')
	" Get current line number
	let current_line = line('.')
	let line = current_line
	" Loop upwards looking for the /* sequence
	  " Search() will return the line number
    let position = search('^\/\*$', 'b', 'W')
	" Search now downwards for the */ sequence
	let position2 = search('^\*\/$', 'W')
	" Last check: if there is a whole file comment
	" and the first line is actually the start of the
	" comment. It happens that if no /* or */ are found,
	" that the initial and end lines are returned from
	" the search() command
	if position == init_line && position2 == last_line
		if getline(init_line) == "/*"
		    exe position . 'd'
			let updated_position2 = position2 - 1
			exe updated_position2 . 'd'
		endif
	else
		if position == position2
			echo 'Not found'
		else
			exe position . 'd'
			let updated_position2 = position2 - 1
			exe updated_position2 . 'd'
		endif
	endif
endfunction
