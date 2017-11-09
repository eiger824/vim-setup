function! CommandExec()
	call inputsave()
	let cmd = input('Enter command: ') 
	call inputrestore()
	echo "\n"
	let result = systemlist(cmd)
	let code = v:shell_error
	let correct = 0
	while correct == 0
		call inputsave()
		let show_or_not = input('Exit code (' . code . '), show output? [N]/y: ')
		call inputrestore()
		if empty(show_or_not) || show_or_not == "N" || show_or_not == "n"
			echo "\nSkipping ..."
			let correct = 1
			call feedkeys("<cr>")
		elseif show_or_not == "y" || show_or_not == "Y"
			echo "\n"
			for line in result
				echo line
			endfor
			let correct = 1
		endif
	endwhile
endfunction
