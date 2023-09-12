# Filter container by name and status
```bash
[ -z "$(docker ps -aq --filter name='^${CONTAINER}$' --filter status=exited --filter status=created)" ] || docker start ${CONTAINER}
```