" Function to look for translation-unit pairs (i.e. header/source files)
" at common locations
" Author: Santiago Pagola

function! GetTranslationUnit()
  let include_line = getline(".")
  let sys_parts = split(include_line, '<')

  " If this is a local include -> search for "
  if sys_parts[0] == include_line
	  let loc_parts = split(include_line, '"')
	  let headerName = split(loc_parts[1], '"')[0]
  else
	  let headerName = split(sys_parts[1], '>')[0]
  endif
	
  " Last check: if relative paths are found
  let simpleHeaderName = split(headerName, '/')[-1]

  let paths = findfile(simpleHeaderName, ".;")
  if empty(paths)
	echo 'WARNING: File not found (' . headerName . ')'
  else
	echo 'Found: ' paths
	execute "edit ". paths
"	execute "rightbelow vsplit " . bufname(paths)
  endif

endfunction
