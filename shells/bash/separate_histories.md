# Separate histories
In **iterm2** go to `Settings`, tab `Profiles` and set **Command**:
```bash
cd <path_to_your_project> && export PROFILE="Foo" && . ~/.settings/history
```

<br>

```bash
% cat ~/.settings/history
#echo "Reading '~/.settings/history' ..."

# In iterm2 go to Settings, tab Profiles and set Command:
#   cd <path_to_your_project> && export _PROFILE="Foo" && . ~/.settings/history

# The env 'SHELL' is a user's default shell and it is does not change.
# If your default shell zsh then 'SHELL' env contains zsh and then if you run 'bash' or 'sh' the 'SHELL' env will continue anyway contain 'zsh'.
# Special var '$0' depends on shell mode: it can contain shell name for interactive mode and script name for non-interactive mode.
# The most reliable way is to use 'ps' util and cut field with the name of current shell.
REAL_SHELL=$(ps | grep $$ | grep -v grep | awk '{ print $4 }' | sed 's/^-*\(.*\)$/\1/')

# echo REAL_SHELL=$REAL_SHELL

# History files will appear in ~/.history directory:
if [ -n "${_PROFILE}" ]; then
  if [ "${REAL_SHELL}" = "sh" ]; then
    export HISTFILE=~/".history/${REAL_SHELL}_history_${_PROFILE}"
  elif [ "${REAL_SHELL}" = "bash" ]; then
    export HISTFILE=~/".history/${REAL_SHELL}_history_${_PROFILE}"
  elif [ "${REAL_SHELL}" = "zsh" ]; then
    export HISTFILE=~/".history/${REAL_SHELL}_history_${_PROFILE}"
  else
    echo "Skipping HISTFILE env setting!"
  fi
  export PSQL_HISTORY=~/".psql_history_${_PROFILE}"
fi

# If the shell is zsh, the variable $ZSH_VERSION is defined.
if [ -n "${ZSH_VERSION}" ]; then
    fc -p "${HISTFILE}"
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_SAVE_NO_DUPS
    setopt INC_APPEND_HISTORY
fi

export SAVEHIST=1000000
export HISTSIZE=200000
%
```