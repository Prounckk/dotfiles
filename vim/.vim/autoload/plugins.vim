scriptencoding utf-8

let s:VIM_MINPAC_FOLDER = expand($VIMHOME . '/pack/minpac')
let s:CURRENT_FILE = expand('<sfile>')

function! plugins#installMinpac() abort
  execute 'silent !git clone https://github.com/k-takata/minpac.git ' . expand(s:VIM_MINPAC_FOLDER . '/opt/minpac')
endfunction

function! plugins#loadPlugins() abort
  silent! packadd minpac

  if !exists('*minpac#init')
    finish
  endif

  command! -bar PackUpdate call plugins#init() | call minpac#update()
  command! -bar PackClean  call plugins#init() | call minpac#clean()

  call minpac#init()
  call minpac#add('https://github.com/k-takata/minpac', { 'type': 'opt' })

  " General {{{
  if !has('nvim')
    call minpac#add('https://github.com/tpope/vim-sensible', { 'type': 'opt' })
    silent! packadd vim-sensible
    if !has('nvim') " For vim
      if exists('&belloff')
        " never ring the bell for any reason
        set belloff=all
      endif
      if has('showcmd')
        " extra info at end of command line
        set showcmd
      endif
      if &term =~# '^tmux'
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      endif
    endif
  endif
  call minpac#add('https://github.com/jiangmiao/auto-pairs')
  call minpac#add('https://github.com/SirVer/ultisnips')
  call minpac#add('https://github.com/duggiefresh/vim-easydir')

  call minpac#add('https://github.com/junegunn/fzf.vim', { 'type': 'opt' })
  if !empty(glob('~/.zplugin/plugins/junegunn---fzf'))
    set runtimepath^=~/.zplugin/plugins/junegunn---fzf
    silent! packadd fzf.vim
  endif
  call minpac#add('https://github.com/Shougo/unite.vim')
  call minpac#add('https://github.com/Shougo/vimfiler.vim', { 'type': 'opt' })
  call minpac#add('https://github.com/junegunn/vim-peekaboo')
  call minpac#add('https://github.com/mbbill/undotree', { 'type': 'opt' })
  call minpac#add('https://github.com/mhinz/vim-grepper', { 'type': 'opt' })
  call minpac#add('https://github.com/mhinz/vim-sayonara', { 'type': 'opt' })
  call minpac#add('https://github.com/mhinz/vim-startify')
  call minpac#add('https://github.com/nelstrom/vim-visual-star-search')
  call minpac#add('https://github.com/tpope/tpope-vim-abolish')
  call minpac#add('https://github.com/tpope/vim-characterize')
  call minpac#add('https://github.com/tpope/vim-commentary')
  call minpac#add('https://github.com/tpope/vim-eunuch')
  call minpac#add('https://github.com/tpope/vim-repeat')
  call minpac#add('https://github.com/tpope/vim-speeddating')
  call minpac#add('https://github.com/tpope/vim-surround')
  let g:surround_indent = 0
  let g:surround_no_insert_mappings = 1

  call minpac#add('https://github.com/wellle/targets.vim')
  call minpac#add('https://github.com/wincent/loupe')
  call minpac#add('https://github.com/wincent/terminus')
  call minpac#add('https://github.com/unblevable/quick-scope')
  let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

  call minpac#add('https://github.com/christoomey/vim-tmux-navigator', {'type': 'opt'})
  if executable('tmux') && !empty($TMUX)
    silent! packadd vim-tmux-navigator
    let g:tmux_navigator_disable_when_zoomed = 1
  endif

  call minpac#add('https://github.com/VincentCordobes/vim-translate', {'type': 'opt'})
  if executable('trans')
    command! -nargs=* Translate :silent! packadd vim-translate | Translate
    command! -nargs=* TranslateReplace :silent! packadd vim-translate | TranslateReplace
    command! -nargs=* TranslateClear :silent! packadd vim-translate | TranslateClear
  endif
  call minpac#add('https://github.com/vimwiki/vimwiki', { 'branch': 'dev' })
  " }}}

  " Autocompletion {{{
  call minpac#add('https://github.com/autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': '!bash ./install.sh' })
  call minpac#add('https://github.com/roxma/nvim-completion-manager', { 'type': 'opt' })
  call minpac#add('https://github.com/roxma/nvim-cm-tern', { 'type': 'opt', 'do': '!yarn global add tern && yarn' })
  call minpac#add('https://github.com/Shougo/neco-vim', { 'type': 'opt' })
  call minpac#add('https://github.com/othree/csscomplete.vim')

  if has('nvim')
    silent! packadd nvim-completion-manager
    silent! packadd neco-vim
    if !executable('flow')
      silent! packadd nvim-cm-tern
    endif
  endif
  " }}}

  " Syntax {{{
  call minpac#add('https://github.com/chrisbra/Colorizer')
  let g:colorizer_auto_filetype='sass,scss,stylus,css,html,html.twig,twig'

  call minpac#add('https://github.com/reasonml-editor/vim-reason-plus')
  call minpac#add('https://github.com/jez/vim-github-hub')
  call minpac#add('https://github.com/sheerun/vim-polyglot')
  let g:polyglot_disabled = ['javascript', 'jsx']

  call minpac#add('https://github.com/neoclide/vim-jsx-improve')
  call minpac#add('https://github.com/direnv/direnv.vim')
  call minpac#add('https://github.com/luochen1990/rainbow')
  let g:rainbow_active = 1
  let g:rainbow_conf = {
        \'guifgs': ['white', 'darkorange3', 'seagreen3', 'firebrick'],
        \'ctermfgs': ['white', 'lightyellow', 'lightcyan', 'lightmagenta'],
        \}

  " Linters & Code quality {{{
  call minpac#add('https://github.com/w0rp/ale', { 'do': '!yarn global add prettier' })
  " }}}

  " Git {{{
  call minpac#add('https://github.com/airblade/vim-gitgutter')
  call minpac#add('https://github.com/lambdalisue/vim-gista')
  call minpac#add('https://github.com/tpope/vim-fugitive')
  call minpac#add('https://github.com/tpope/vim-rhubarb')
  " }}}

  " Writing {{{
  call minpac#add('https://github.com/junegunn/goyo.vim', { 'type': 'opt' })
  command! -nargs=* Goyo :silent! packadd goyo.vim | Goyo

  call minpac#add('https://github.com/junegunn/limelight.vim', { 'type': 'opt' })
  command! -nargs=* Limelight :silent! packadd limelight.vim | Limelight
  " }}}

  " Themes, UI & eye cnady {{{
  call minpac#add('https://github.com/tomasiser/vim-code-dark', { 'type': 'opt' })
  call minpac#add('https://github.com/tyrannicaltoucan/vim-deep-space', { 'type': 'opt' })
  call minpac#add('https://github.com/morhetz/gruvbox', { 'type': 'opt' })
  call minpac#add('https://github.com/icymind/NeoSolarized', { 'type': 'opt' })
  call minpac#add('https://github.com/rakr/vim-two-firewatch', { 'type': 'opt' })
  call minpac#add('https://github.com/logico-dev/typewriter', { 'type': 'opt' })
  call minpac#add('https://github.com/agreco/vim-citylights', { 'type': 'opt'  })
  call minpac#add('https://github.com/atelierbram/Base2Tone-vim', { 'type': 'opt'  })
  " minimal
  call minpac#add('https://github.com/andreypopp/vim-colors-plain', { 'type': 'opt'  })
  call minpac#add('https://github.com/owickstrom/vim-colors-paramount', { 'type': 'opt'  })
  " }}}
endfunction

if !exists('*plugins#init')
  function! plugins#init() abort
    exec 'source ' . s:CURRENT_FILE

    if empty(glob(s:VIM_MINPAC_FOLDER))
      call plugins#installMinpac() | call plugins#loadPlugins() | call minpac#update()
    else
      call plugins#loadPlugins()
    endif
  endfunction
endif
