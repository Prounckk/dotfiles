scriptencoding utf-8

function! statusline#rhs() abort
  return winwidth(0) > 80 ? printf('%02d:%02d:%02d', line('.'), col('.'), line('$')) : ''
endfunction

" For a more fancy ale statusline
" https://github.com/w0rp/ale#5iv-how-can-i-show-errors-or-warnings-in-my-statusline
function! statusline#LinterStatus() abort
  if !exists(':ALEInfo')
    return ''
  endif

  let l:error_symbol = '⨉'
  let l:style_symbol = '●'
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:ale_linter_status = ''

  if l:counts.total == 0
    return printf('%%#GitGutterAdd#%s%%*', l:style_symbol)
  endif

  if l:counts.error
    let l:ale_linter_status .= printf('%%#GitGutterDelete#%d %s %%*', l:counts.error, l:error_symbol)
  endif
  if l:counts.warning
    let l:ale_linter_status .= printf('%%#GitGutterChange#%d %s %%*', l:counts.warning, l:error_symbol)
  endif
  if l:counts.style_error
    let l:ale_linter_status .= printf('%%#GitGutterDelete#%d %s %%*', l:counts.style_error, l:style_symbol)
  endif
  if l:counts.style_warning
    let l:ale_linter_status .= printf('%%#GitGutterChange#%d %s %%*', l:counts.style_warning, l:style_symbol)
  endif

  return l:ale_linter_status
endfunction

" Modified from here
" https://github.com/mhinz/vim-signify/blob/748cb0ddab1b7e64bb81165c733a7b752b3d36e4/doc/signify.txt#L565-L582
function! statusline#GetHunks() abort
  if !exists('*GitGutterGetHunkSummary')
    return ''
  endif

  let l:symbols = ['+', '-', '~']
  let [l:added, l:modified, l:removed] = GitGutterGetHunkSummary()
  let l:stats = [l:added, l:removed, l:modified]  " reorder
  let l:hunkline = ''

  for l:i in range(3)
    if l:stats[l:i] > 0
      let l:hunkline .= printf('%s%s ', l:symbols[l:i], l:stats[l:i])
    endif
  endfor

  if !empty(l:hunkline)
    let l:hunkline = '%4* ['. l:hunkline[:-2] .']%*'
  endif

  return l:hunkline
endfunction

function! statusline#gitInfo() abort
  if !exists('*fugitive#head')
    return ''
  endif

  let l:out = fugitive#head(10)
  if !empty(l:out) || !empty(expand('%'))
    let l:out = ' ' . l:out
  endif
  return l:out
endfunction

function! statusline#readOnly() abort
  if !&modifiable && &readonly
    return ' RO'
  elseif &modifiable && &readonly
    return 'RO'
  elseif !&modifiable && !&readonly
    return ''
  else
    return ''
  endif
endfunction

function! statusline#modified() abort
  return &modified ? '%#WarningMsg# [+]' : '%6*'
endfunction

function! statusline#fileprefix() abort
  let l:basename=expand('%:h')
  if l:basename ==# '' || l:basename ==# '.'
    return ''
  else
    " Make sure we show $HOME as ~.
    return substitute(l:basename . '/', '\C^' . $HOME, '~', '')
  endif
endfunction

" DEFINE MODE DICTIONARY
let s:dictmode= {
      \ 'n': ['N.', '4'],
      \ 'no': ['N-Operator Pending', '4'],
      \ 'v': ['V.', '6'],
      \ 'V': ['V·Line', '6'],
      \ '': ['V·Block', '6'],
      \ 's': ['S.', '3'],
      \ 'S': ['S·Line', '3'],
      \ '': ['S·Block.', '3'],
      \ 'i': ['I.', '5'],
      \ 'R': ['R.', '1'],
      \ 'Rv': ['V·Replace', '1'],
      \ 'c': ['Command', '2'],
      \ 'cv': ['Vim Ex', '7'],
      \ 'ce': ['Ex', '7'],
      \ 'r': ['Propmt', '7'],
      \ 'rm': ['More', '7'],
      \ 'r?': ['Confirm', '7'],
      \ '!': ['Sh', '2'],
      \ 't': ['T', '2']
      \ }

" DEFINE COLORS FOR STATUSBAR
" @TODO: Fix cterm.
let s:statusline_color=printf('highlight! StatusLine gui=NONE cterm=NONE guibg=NONE ctermbg=NONE guifg=%s ctermfg=%s', synIDattr(hlID('Identifier'),'fg', 'gui'), synIDattr(hlID('Identifier'),'fg', 'cterm'))
let s:dictstatuscolor={
      \ '1': s:statusline_color,
      \ '2': s:statusline_color,
      \ '3': s:statusline_color,
      \ '4': s:statusline_color,
      \ '5': s:statusline_color,
      \ '6': s:statusline_color,
      \ '7': s:statusline_color,
      \}


" GET CURRENT MODE FROM DICTIONARY AND RETURN IT
" IF MODE IS NOT IN DICTIONARY RETURN THE ABBREVIATION
" GetMode() GETS THE MODE FROM THE ARRAY THEN RETURNS THE NAME
function! statusline#getMode() abort
  let l:modenow = mode()
  let l:modelist = get(s:dictmode, l:modenow, [l:modenow, '1'])
  let l:modecolor = l:modelist[1]
  let l:modename = l:modelist[0]
  let l:modehighlight = get(s:dictstatuscolor, l:modecolor, '1')
  exec l:modehighlight
  return l:modename
endfunction
