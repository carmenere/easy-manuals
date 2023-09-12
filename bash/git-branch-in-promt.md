# 
Add to `~/.zshrc` following:
```bash
function git_branch() {
    git branch --show-current 2> /dev/null
}

setopt PROMPT_SUBST
export PS1='%F{green}%n%f@%F{red}%m%f %3~ [$(git_branch)] %# '
```