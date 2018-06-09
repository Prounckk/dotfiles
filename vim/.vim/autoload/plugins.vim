let s:VIM_PLUG=expand($VIMHOME.'/autoload/plug.vim')
let s:VIM_PLUG_FOLDER=expand($VIMHOME.'/plugged')

function! plugins#installVimPlug() abort
  " Automatic installation
  " https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation
  execute 'silent !curl -fLo '.s:VIM_PLUG.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  augroup MyVimPlug
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endfunction

" https://github.com/junegunn/vim-plug/wiki/faq#conditional-activation
function! plugins#If(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

function! plugins#loadPlugins() abort
  call plug#begin(s:VIM_PLUG_FOLDER)
  " General {{{
  Plug 'tpope/vim-sensible', plugins#If(!has('nvim'))
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

  Plug 'SirVer/ultisnips'
  Plug 'jiangmiao/auto-pairs'
  Plug 'duggiefresh/vim-easydir'
  if !empty(glob('~/.zplugin/plugins/junegunn---fzf'))
    set runtimepath+=~/.zplugin/plugins/junegunn---fzf
    Plug 'junegunn/fzf.vim'
  endif
  Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }
  Plug 'mhinz/vim-grepper', { 'on': ['Grepper'] }
  Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
  Plug 'mhinz/vim-startify'
  Plug 'Shougo/unite.vim'
        \| Plug 'Shougo/vimfiler.vim', { 'on': ['VimFiler', 'VimFilerExplorer'] }
  Plug 'tpope/tpope-vim-abolish'
  Plug 'tpope/vim-apathy'
  Plug 'tpope/vim-characterize'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-speeddating'
  Plug 'tpope/vim-surround'
  let g:surround_indent = 0
  let g:surround_no_insert_mappings = 1

  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/vim-peekaboo'
  Plug 'wincent/loupe'
  Plug 'wincent/terminus'
  Plug 'wellle/targets.vim'
  Plug 'nelstrom/vim-visual-star-search'
  Plug 'unblevable/quick-scope'
  let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

  Plug 'christoomey/vim-tmux-navigator', plugins#If(executable('tmux') && !empty($TMUX))
  let g:tmux_navigator_disable_when_zoomed = 1

  if executable('trans')
    Plug 'VincentCordobes/vim-translate', { 'on': ['Translate', 'TranslateReplace', 'TranslateClear'] }
  endif
  Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
  " }}}

  " Autocomplete {{{
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash ./install.sh' }
  Plug 'othree/csscomplete.vim'
  if has('nvim')
    Plug 'roxma/nvim-completion-manager'
    Plug 'roxma/nvim-cm-tern', plugins#If(!executable('flow'), { 'do': 'yarn global add tern && yarn' })
    Plug 'Shougo/neco-vim'
  endif
  " }}}

  " Syntax {{{
  Plug 'https://github.com/chrisbra/Colorizer'
  let g:colorizer_auto_filetype='sass,scss,stylus,css,html,html.twig,twig'

  Plug 'reasonml-editor/vim-reason-plus'
  Plug 'jez/vim-github-hub'
  Plug 'sheerun/vim-polyglot'
  let g:polyglot_disabled = ['javascript', 'jsx']

  Plug 'chemzqm/vim-jsx-improve'
  Plug 'direnv/direnv.vim'
  Plug 'luochen1990/rainbow'
  let g:rainbow_active = 1
  let g:rainbow_conf = {
        \'guifgs': ['white', 'darkorange3', 'seagreen3', 'firebrick'],
        \'ctermfgs': ['white', 'lightyellow', 'lightcyan', 'lightmagenta'],
        \}

  " Linters & Code quality {{{
  Plug 'w0rp/ale', { 'do': 'yarn global add prettier' }
  " }}}

  " Themes, UI & eye candy {{{
  Plug 'tomasiser/vim-code-dark'
  Plug 'tyrannicaltoucan/vim-deep-space'
  Plug 'morhetz/gruvbox'
  Plug 'icymind/NeoSolarized'
  Plug 'rakr/vim-two-firewatch'
  Plug 'logico-dev/typewriter'
  Plug 'agreco/vim-citylights'
  Plug 'atelierbram/Base2Tone-vim'
  " minimal
  Plug 'andreypopp/vim-colors-plain'
  Plug 'owickstrom/vim-colors-paramount'
  " }}}

  " Git {{{
  Plug 'airblade/vim-gitgutter'
  Plug 'lambdalisue/vim-gista'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  " }}}

  " Writing {{{
  Plug 'junegunn/goyo.vim', { 'on': ['Goyo']}
  Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }
  " }}}
  call plug#end()
endfunction

if !exists('*plugins#init')
  function! plugins#init() abort
    if empty(glob(s:VIM_PLUG)) || (!empty(glob(s:VIM_PLUG)) && empty(glob(s:VIM_PLUG_FOLDER)))
      call plugins#installVimPlug() | call plugins#loadPlugins()
    else
      call plugins#loadPlugins()
    endif
  endfunction
endif
