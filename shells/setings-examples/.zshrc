echo "Reading '~/.zshrc' ..."

# man zsh:
#   options: https://zsh.sourceforge.io/Doc/Release/Options.html
#   environments: https://zsh.sourceforge.io/Doc/Release/Parameters.html

if [ -f ~/.env ]; then
  . ~/.env
fi

eval "$(direnv hook zsh)"
direnv allow .

# History settings: setopt|unsetopt
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

function history_read() {
  if [ "${HISTFILE}" != "${HISTFILE_PREV}" ]; then
    echo "Reading history from '${HISTFILE}' ... "
    fc -R "${HISTFILE}"
    HISTFILE_PREV="${HISTFILE}"
  fi
}

precmd_functions+=(history_read)

#
autoload -U colors && colors
autoload -Uz compinit && compinit

# Promt
setopt PROMPT_SUBST
export PS1='%F{green}%n%f@%F{red}%m%f %3~ [$(git branch --show-current 2>/dev/null)] %# '
