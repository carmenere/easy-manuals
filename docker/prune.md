# Clear all containers, images and volumes

<br>

## Stop all containers
```bash
docker stop $(docker ps -aq)
```

<br>

## Stop and remove all containers
```bash
[ -z "$(docker ps -aq)" ] || docker rm --force $(docker ps -aq)
```

<br>

## Prune
```bash
docker system prune --force --all --volumes
```

<br>

## Prune all (+ builder cache)
```bash
docker system prune --force --all --volumes
docker volume prune --force
docker network prune --force
docker builder prune --force --all
```