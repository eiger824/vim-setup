function! RemoveTrailingWhitespaces()
	let pattern = '+'
	execute "/\\s" . fnameescape(pattern) . "$"
	call inputsave()
	let c = input('Remove?[Y|n]: ')
	call inputrestore()

	echo 'C: value is: ' c

	if empty(c)
			execute ":%s/\\s" . fnameescape(pattern) . "$//g"
	else
			if c == "N" || c == "n"
					echo "Skipping"
			else
					execute ":%s/\\s" . fnameescape(pattern) . "$//g"
			endif
	endif
endfunction
