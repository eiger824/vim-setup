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

  " Start the file seach from the top .git parent-directory,
  " assumming the directory hierarchy is version-controlled
"  let paths = findfile(simpleHeaderName, ".;")
  let rootDir2 = finddir(".git", ".;")
  let rootDir1 = fnamemodify(rootDir2, ':p')
  let rootDir_split = split(rootDir1, '/')
  let rootDir_tmp = join(rootDir_split[:-2], '/')
  let rootDir = '/'.rootDir_tmp

  if empty(rootDir)
	echo 'WARNING: No .git directories were found, skipping search'
  else
	let paths = system("find " . rootDir . " -name " . simpleHeaderName)
	if empty(paths)
	  echo 'WARNING: File not found (' . headerName . ')'
    else
      echo 'Found: ' . paths
	  "execute "edit ". paths
	  execute "rightbelow vsplit " . paths
    endif
  endif

endfunction
