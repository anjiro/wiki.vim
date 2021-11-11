" A simple wiki plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

if !exists('g:ctrlp_ext_vars') | finish | endif

call add(g:ctrlp_ext_vars, {
      \ 'init': 'ctrlp#wiki#toc#init()',
			\ 'enter': 'ctrlp#wiki#toc#gather()',
      \ 'accept': 'ctrlp#wiki#toc#accept',
      \ 'lname': 'wiki toc',
      \ 'sname': 'wt',
      \ 'type': 'line',
      \ 'opmul': 0,
			\ 'sort': 0,
      \ })

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#wiki#toc#id() " {{{1
  return s:id
endfunction

" }}}1
function! ctrlp#wiki#toc#gather() abort " {{{1
  let l:toc = wiki#toc#gather_entries()
  let l:lines = []
  for l:entry in l:toc
    let l:line = repeat('#', l:entry.level - 1) . ' '
					\ . l:entry.header . ' |' . l:entry.lnum . '|'
    call add(l:lines, l:line)
  endfor

	echom "return" len(l:lines) "toc possibilites"
	let s:lines = l:lines
endfunction

function! ctrlp#wiki#toc#init() abort " {{{1
	return s:lines
endfunction

" }}}1
function! ctrlp#wiki#toc#accept(mode, line) " {{{1
  let l:lnum = split(a:line, '|')[1]
	call ctrlp#exit()
  execute l:lnum
endfunction
