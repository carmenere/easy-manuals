# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [`SHELL` env](#shell-env)
* [Separate histories](#separate-histories)
  * [`direnv` util](#direnv-util)
  * [ZSH](#zsh)
* [Bash](#bash)
<!-- TOC -->

<br>

# `SHELL` env
The env `SHELL` is a **user's default shell** and it is does not change. It is set in `/etc/passwd`.<br>
If your default shell **zsh** then `SHELL` env contains **zsh** and then if you run `bash` or `sh` the `SHELL` env will continue anyway contain **zsh**.<br>
Special var `$0` **depends on shell mode**: it may contain **shell name** for interactive mode and **script name** for non-interactive mode.<br>

The most reliable way is to use 'ps' util and cut field with the name of current shell:
`REAL_SHELL=$(ps | grep $$ | grep -v grep | awk '{ print $4 }' | sed 's/^-*\(.*\)$/\1/')`

<br>

# Separate histories
## `direnv` util
You must install `direnv` before. Or you must define you **own hook** for `cd` command, for example:
```bash
function cd() {
  builtin cd "$@" || return
  YOU LOGIC HERE ....
}
```

<br>

Create file `.envrc` in project and add to it following:
```bash
export HIST_PROFILE=tetrix
export HISTFILE_PREV="${HISTFILE}"
export HISTFILE="${HIST_DIR}/shell_${HIST_PROFILE}"
```

Every time you will enter directory with this file `direnv` will load vars above and `HISTFILE` is changed.<br>

<br>

## ZSH
Add to `~/.zshrc` following:
```bash
# History settings
# HIST_PROFILE and HISTFILE are empty by default.

export HIST_DIR=~/.history

if [ ! -d "${HIST_DIR}" ]; then
  mkdir -p "${HIST_DIR}"
fi

HIST_DIR=$(realpath ~/.history)

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
```

<br>

The `HIST_PROFILE` and `HISTFILE` are **empty by default**.<br>
The `precmd_functions` is a special **zsh hook**.<br>
The `history_read` function **reread** `${HISTFILE}` file every time **path** to it is **changed**.<br>

<br>

# Bash
Add to `~/.bashrc` following:
```bash
# History settings
# HIST_PROFILE and HISTFILE are empty by default.

export HIST_DIR=~/.history

if [ ! -d "${HIST_DIR}" ]; then
  mkdir -p "${HIST_DIR}"
fi

HIST_DIR=$(realpath ~/.history)

export HISTFILESIZE=10000000
export HISTSIZE=1000000
export HISTCONTROL=ignoredups

# When you exit from a bash, it saves the history list in $HISTFILE.
# PROMPT_COMMAND='history -a' forces bash to save each command in $HISTFILE immediately.
export PROMPT_COMMAND='history -a'

eval "$(direnv hook bash)"
direnv allow .
```

<br>

The `HIST_PROFILE` and `HISTFILE` are **empty by default**.<br>
The `PROMPT_COMMAND='history -a'` forces bash to save each command in `$HISTFILE` immediately.<br>
