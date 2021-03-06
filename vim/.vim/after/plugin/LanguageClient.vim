if !exists(':LanguageClientStart')
  finish
endif

let g:LanguageClient_autoStart = 1
let g:LanguageClient_completionPreferTextEdit = 1
" let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_loggingLevel='DEBUG'
let g:LanguageClient_serverCommands = {}

if executable('flow') && executable('flow-language-server')
  let g:LanguageClient_serverCommands.javascript = ['flow-language-server', '--stdio']
  let g:LanguageClient_serverCommands['javascript.jsx'] = ['flow-language-server', '--stdio']
endif

if !(executable('flow') && executable('flow-language-server')) && executable('javascript-typescript-stdio')
  let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
  let g:LanguageClient_serverCommands['javascript.jsx'] = ['javascript-typescript-stdio']
endif

if executable('ocaml-language-server')
  let g:LanguageClient_serverCommands.reason = ['ocaml-language-server', '--stdio']
  let g:LanguageClient_serverCommands.ocaml = ['ocaml-language-server', '--stdio']
endif

if executable('pyls')
  let g:LanguageClient_serverCommands.python = ['pyls']
endif

if executable('rls')
  " Requires to run `rustup component add rls-preview rust-analysis rust-src`
  let g:LanguageClient_serverCommands.rust = ['rustup', 'run', 'stable', 'rls']
endif

augroup LanguageClientConfig
  autocmd!
  autocmd FileType javascript,javascript.jsx let g:LanguageClient_diagnosticsEnable = 0
augroup END

if !has('nvim')
  aug VIM_COMPLETION
    au!
    autocmd FileType javascript,javascript.jsx setlocal omnifunc=LanguageClient#complete
    autocmd FileType python setlocal omnifunc=LanguageClient#complete
    autocmd FileType rust setlocal omnifunc=LanguageClient#complete
    autocmd FileType ocaml,reason setlocal omnifunc=LanguageClient#complete
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
  aug END
end

aug lang_client_mappings
  au!
  au User LanguageClientBufReadPost nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
  au User LanguageClientBufReadPost nnoremap <buffer> gd :call LanguageClient#textDocument_definition()<CR>
  au User LanguageClientBufReadPost nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
augroup END
