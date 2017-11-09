function! CommandExec()
	call inputsave()
	let cmd = input('Enter command: ') 
	call inputrestore()
	echo "\n"
	let result = systemlist(cmd)
	for line in result
		echo line
	endfor
endfunction
