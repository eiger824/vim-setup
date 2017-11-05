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
