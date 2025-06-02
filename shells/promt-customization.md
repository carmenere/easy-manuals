# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [ZSH](#zsh)
* [Bash](#bash)
<!-- TOC -->

<br>

# ZSH
Add to `~/.zshrc` following:
```bash
setopt PROMPT_SUBST
export PS1='%F{green}%n%f@%F{red}%m%f %3~ [$(git branch --show-current 2>/dev/null)] %# '
```

`$(git branch --show-current 2>/dev/null)` returns name of branch or nothing.<br>

<br>

# Bash
Add to `~/.bashrc` following:
```bash
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
```
