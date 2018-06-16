scriptencoding utf-8

if !exists(':GitGutter')
  finish
endif

augroup MyGitGutter
  autocmd!
  autocmd BufWritePost * GitGutter
augroup END

let g:gitgutter_diff_args = '--ignore-all-space'
let g:gitgutter_grep_command = executable('rg') ? 'rg' : 'grep'
let g:gitgutter_sign_added='┃'
let g:gitgutter_sign_modified='┃'
let g:gitgutter_sign_removed='◢'
let g:gitgutter_sign_removed_first_line='◥'
let g:gitgutter_sign_modified_removed='◢'

call gitgutter#highlight#define_signs()
