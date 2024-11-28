echo "Reading '~/.profile' ..."

if [ -f ~/.settings/index ]; then
  . ~/.settings/index
fi
