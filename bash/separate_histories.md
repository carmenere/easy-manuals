# Separate histories
In **iterm2** go to `Settings`, tab `Profiles` and set **Command**:
```bash
cd <path_to_your_project> && export PROFILE="Foo" && . ~/.separate_histories
```

<br>

```bash
cat ~/.separate_histories
if [ -n $PROFILE ]
then
    export HISTFILE="$(realpath ~)/.zsh_history_${PROFILE}"
    fc -p "${HISTFILE}"
    export PSQL_HISTORY="/Users/bar/.psql_history_${PROFILE}"
fi
```