" A simple wiki plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

if !exists('g:ctrlp_ext_vars') | finish | endif

call add(g:ctrlp_ext_vars, {
      \ 'init': 'ctrlp#wiki#init()',
      \ 'accept': 'ctrlp#wiki#accept',
      \ 'lname': 'wiki files',
      \ 'sname': 'wf',
      \ 'type': 'path',
      \ 'opmul': 1,
      \ })

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#wiki#id() " {{{1
  return s:id
endfunction

" }}}1
function! ctrlp#wiki#init() abort " {{{1
	if exists('g:ctrlp_user_command')
		let l:files = wiki#jobs#capture(printf(
					\ (type(g:ctrlp_user_command) == type('')
					\  ? g:ctrlp_user_command
					\  : get(g:ctrlp_user_command, -1)),
					\ s:root))
	else
		let l:root = wiki#get_root() . s:slash
		let l:extension = len(g:wiki_filetypes) == 1
					\ ? g:wiki_filetypes[0]
					\ : '{' . join(g:wiki_filetypes, ',') . '}'
		let l:files = globpath(l:root, '**/*.' . l:extension, v:false, v:true)
	endif

  call filter(l:files,
        \ 'v:val =~# ''\v%(' . join(g:wiki_filetypes, '|') . ')$''')
  if empty(l:files) | return l:files | endif

  let s:extension = fnamemodify(l:files[0], ':e')
  call map(l:files,
        \ 'strpart(fnamemodify(v:val, '':r''), len(s:root)+1)')

  return sort(l:files)
endfunction

" }}}1
function! ctrlp#wiki#accept(md, path) " {{{1
  call ctrlp#acceptfile(a:md,
        \ wiki#paths#s(printf('%s/%s.%s', s:root, a:path, s:extension)))
endfunction

" }}}1
let s:slash = exists('+shellslash') && !&shellslash ? '\' : '/'
