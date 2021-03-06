unalias l 2> /dev/null

l(){
  if (( $+commands[exa] )); then
    if [[ "$1" == '--help' ]]; then
      exa --help
    else
      exa --all --long --header --links --color-scale --group-directories-first --sort=type "$@"
    fi
  elif [[ -x "${HOMEBREW_ROOT:-/usr/local}/opt/coreutils/libexec/gnubin/ls" ]]; then
    # https://github.com/paulirish/dotfiles/blob/7c46f8c25015c2632894dbe5fea20014ab37fd89/.functions#L14-L25
    # @TODO: Check why this is not picked up from $PATH?
    ${HOMEBREW_ROOT:-/usr/local}/opt/coreutils/libexec/gnubin/ls --almost-all -l --human-readable --classify -alph --group-directories-first --color=always "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
  else
    # List all files, long format, colorized, permissions in octal
    ls -l "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
  fi
}
