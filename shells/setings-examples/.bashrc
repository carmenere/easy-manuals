echo "Reading '~/.bashrc' ..."

# man:
#   environments: https://www.gnu.org/software/bash/manual/bash.html#Shell-Variables

if [ -f ~/.env ]; then
  . ~/.env
fi

# History settings
# The default value is ~/.bash_history.
export HISTFILESIZE=10000000
export HISTSIZE=1000000
export HISTCONTROL=ignoredups

# When you exit from a bash, it saves the history list in $HISTFILE.
# PROMPT_COMMAND='history -a' forces bash to save each command in $HISTFILE immediately.
export PROMPT_COMMAND='history -a'

eval "$(direnv hook bash)"
direnv allow .

# Color vars
BLINK='\033[5m'
BLUE='\033[;34m'
BOLD='\033[1m'
GREEN='\033[;32m'
RED='\033[;31m'
RESET='\033[0m'
UNDERLINE='\033[4m'

# BG stands for BackGround
BG_BLUE='\033[;44m'
BG_GREEN='\033[;42m'
BG_RED='\033[;41m'

# root
PS_SEPARATOR="#"
# user
PS_SEPARATOR="\$"

export PS1="${GREEN}${BOLD}\u${RESET}@${RESET}${RED}${BOLD}\h:${RESET}\w [\$(git branch --show-current 2>/dev/null)] ${PS_SEPARATOR} ${RESET}"
