# docker inspect
## Prerquisites
Install tool ``jq``:
```bash
apt install jq
```

<br>

## Full config of container ``CONTAINER_NAME``
To get full config of some container ``CONTAINER_NAME`` run:
```bash
docker inspect -f '{{json .}}' CONTAINER_NAME | jq '.'
```

<br>

## Network settings of container ``CONTAINER_NAME``
```bash
docker inspect -f '{{json .}}' CONTAINER_NAME | jq '.NetworkSettings.Networks' | jq .
```
<br>

## Envs of container ``CONTAINER_NAME``
```bash
docker inspect -f '{{json .}}' CONTAINER_NAME | jq '.Config.Env' | jq .
or
docker inspect -f '{{json .}}' so_api | jq '.Config.Env[]' | jq .
```