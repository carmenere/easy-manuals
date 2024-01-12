# Docker volumes vs. Bind Mounts
Docker provides **volumes** and **bind mounts**, two mechanisms for persisting data in your Docker container.<br>

<br>

## Bind Mounts
**Bind mounts** will **mount** a *file* or *directory* on the **host machine** to **container**.<br>

<br>

## Docker Volumes
**Docker volumes** are **completely handled by Docker** itself and therefore independent of both your directory structure and the OS of the host machine.

<br>

## Options
### Docker volume
`-v host_path:container_path:opts` or `--volume host_path:container_path:opts`:
- field `host_path` is the path to the file or directory on the **host machine**;
- field `container_path` is the path to the file or directory **inside the container**;
- field `opts` is **optional**, and is a **comma-separated list of options**, such as `ro`, `rw`, `z` and `Z`;

<br>

### Bind mount
`--mount <args>` where <args> consists of multiple `<key>=<value>` pairs, separated by commas, possible `keys`:
- `type` defines the **type of the mount**, which can be `bind`, `volume` (Docker volume), or `tmpfs`;
- `source` or `src` is the path to the file or directory on the **host machine**;
- `destination` or `dst` or `target` is the path to the file or directory **inside the container**;
- The `readonly` option, if present, causes the bind mount to be mounted into the container as **read-only**;

<br>

## Example
`docker run -p 127.0.0.1:3000:3000 --mount type=bind,src="$(pwd)",target=/app`
