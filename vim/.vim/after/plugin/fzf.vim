" FZF
let g:fzf_files_options = $FZF_CTRL_T_OPTS
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_commits_log_options = $FZF_VIM_LOG
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags -R'

command! Plugs call fzf#run({
  \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
  \ 'options': '--delimiter / --nth -1',
  \ 'sink':    'Explore'})

" color=always makes fzf slow, not a ripgrep issues
" https://github.com/junegunn/fzf.vim/issues/488#issuecomment-346909854
" https://github.com/BurntSushi/ripgrep/issues/696
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=never '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <Leader>c :Colors<cr>
nnoremap <silent> <Leader>b :Buffers<cr>
nnoremap <silent> <Leader>h :Helptags<cr>

function! s:fzf_statusline() abort
  " hi! link fzf1 User4
  " hi! link fzf2 User6
  " hi! link fzf3 User9
  setlocal statusline=%4*\ fzf\ %6*V:\ ctrl-v,\ H:\ ctrl-x
endfunction

augroup MyFZF
  autocmd!
  autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END
