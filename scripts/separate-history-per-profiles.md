# zsh
```bash
if [ -n $PROFILE ]
then
    export HISTFILE="$(realpath ~)/.zsh_history_${PROFILE}"
    fc -p "${HISTFILE}"
    export PSQL_HISTORY="/Users/an.romanov/.psql_history_${PROFILE}"
fi
```
