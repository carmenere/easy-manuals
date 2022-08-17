# Clear all containers, images and volumes

<br>

## Stop all containers
```bash
docker stop $(docker ps -aq)
```

<br>

## Prune
```bash
docker system prune -f -a --volumes
```
