# vim:ft=zsh:

##############################################################
# Profiling.
##############################################################

# uncomment to profile & run `zprof`
# zmodload zsh/zprof

##############################################################
# zPlug.
##############################################################

if [[ ! -f ~/.zplug/init.zsh ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build:"zplug --self-manage"
NVM_NO_USE=true
zplug "lukechilds/zsh-nvm"

export ZIM_HOME="$ZPLUG_REPOS/zimfw/zimfw"
zplug "zimfw/zimfw", depth:1
# Zim settings
zmodules=(
  directory
  environment
  history
  meta
  input
  utility
  # custom
  autosuggestions
  syntax-highlighting
  history-substring-search
  prompt
  completion
)

zplug "ahmedelgabri/pure", depth:1, use:"{async,pure}.zsh", as:theme
zplug "knu/z", use:"z.sh", depth:1, defer:1
zplug "lukechilds/zsh-better-npm-completion", defer:1
zplug "molovo/tipz", defer:1
zplug "zdharma/fast-syntax-highlighting", defer:1

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# zplug load --verbose
zplug load

ztermtitle="%n@%m:%~"
zdouble_dot_expand="true"
ZSH_AUTOSUGGEST_USE_ASYNC=true
TIPZ_TEXT='Alias tip:'

##############################################################
# CONFIG.
##############################################################

for config (~/.dotfiles/zsh/zshrc.d/config/*.zsh) source $config
for func (~/.dotfiles/zsh/zshrc.d/config/functions/*.zsh) source $func

##############################################################
# ENV OVERRIDES
##############################################################
# Make some commands not show up in history
HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"
HISTSIZE=100000
SAVEHIST=$HISTSIZE

##############################################################
# TOOLS.
##############################################################

(( $+commands[grc] )) && source "`brew --prefix`/etc/grc.bashrc"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

##############################################################
# /etc/motd
##############################################################

if [ -e /etc/motd ]; then
  if ! cmp -s $HOME/.hushlogin /etc/motd; then
    tee $HOME/.hushlogin < /etc/motd
  fi
fi

##############################################################
# LOCAL.
##############################################################

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

##############################################################
# direnv.
##############################################################

if [ $(command -v direnv) ]; then
  export NODE_VERSIONS="$HOME/.nvm/versions/node"
  export NODE_VERSION_PREFIX="v"

  eval "$(direnv hook zsh)"
fi
