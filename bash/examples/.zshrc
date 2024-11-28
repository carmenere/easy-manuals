echo "Reading '~/.zshrc' ..."

if [ -f ~/.settings/index ]; then
  . ~/.settings/index
fi

autoload -U colors && colors
autoload -Uz compinit && compinit
