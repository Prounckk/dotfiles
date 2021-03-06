# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath manpath mailpath path

##############################################################
# PATH.
# (N-/): do not register if the directory does not exists
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
##############################################################

fpath=(
  ${ZDOTDIR:-${HOME}}/completions(N-/)
  /usr/local/share/zsh/site-functions(N-/)
  $fpath
)

manpath=(
  ${HOMEBREW_ROOT:-/usr/local}/opt/coreutils/libexec/gnuman(N-/)
  $manpath
)

# Set the the list of directories that cd searches.
cdpath=(
  $cdpath
)

# Set the list of directories that Zsh searches for programs.
path=(
  ${DOTFILES}/bin(N-/)
  ./node_modules/.bin
  ${HOMEBREW_ROOT:-/usr/local}/opt/python/libexec/bin(N-/)
  /usr/local/{bin,sbin}
  ${HOMEBREW_ROOT:-/usr/local}/opt/coreutils/libexec/gnubin(N-/)
  # Until yarn fixes itself & link binaries to `/usr/local/bin`
  ${XDG_CONFIG_HOME}/yarn/global/node_modules/.bin(N-/)
  ${HOME}/.cargo/bin(N-/)
  ${GOPATH}/bin(N-/)
  ${HOME}/Library/Python/3.*/bin(Nn[-1]-/)
  ${HOME}/Library/Python/2.*/bin(Nn[-1]-/)
  # $(${HOMEBREW_ROOT:-/usr/local}/bin/python3 -m site --user-base)/bin(N-/)
  # $(${HOMEBREW_ROOT:-/usr/local}/bin/python2 -m site --user-base)/bin(N-/)
  $path
)

for config (${ZDOTDIR}/rc.d/config/*.zsh) source $config

