scriptencoding utf-8

let g:ale_fix_on_save = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_echo_msg_format = '[%linter%] %s'

let g:PRETTIER_OPTS='--parser ' .(g:current_flow_path ==# 'flow not found' ?  'babylon' : 'flow'). ' --single-quote --trailing-comma es5'
let g:ale_javascript_prettier_options = g:PRETTIER_OPTS. ' --no-semi'
let g:ale_css_prettier_options = '--parser postcss'
let g:ale_scss_prettier_options = '--parser postcss'
let g:ale_json_prettier_options = '--parser json'

let g:ale_linter_aliases = {'reason': 'ocaml'}
let g:ale_linters = {
      \ 'javascript': ['eslint', 'flow'],
      \ 'css': ['stylelint'],
      \ 'scss': ['stylelint'],
      \}
let g:ale_fixers = {
  \   'javascript': [
  \       'prettier',
  \   ],
  \   'css': [
  \       'prettier',
  \   ],
  \   'scss': [
  \       'prettier',
  \   ],
  \}