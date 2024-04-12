# On the host
## Pull ubuntu image
```bash
docker pull ubuntu
```

<br>

# Run ubuntu
```bash
docker run -ti ubuntu /bin/bash
```

<br>

## Connect to container in other session
1. `docker ps -a` get list of containers and find running ubuntu and copy its `id`, for example `23b3d71f06e9`.
2. Connect to container with `id=23b3d71f06e9`:  `docker exec -ti 23b3d71f06e9 /bin/bash`

<br>

# Inside the docker container
## Install soft
```bash
apt update
apt install netcat-openbsd
apt install curl
apt install tcpdump
apt install vim
apt install lsof
apt install nginx
```

<br>

## Nginx
## Clear configs
```bash
:> /main.conf
:> /upstream.conf
```

<br>

## Edit configs
```bash
vi /main.conf
vi /upstream.conf
```

<br>

## Reload nginx
```bash
/usr/sbin/nginx -c /main.conf -s reload
/usr/sbin/nginx -c /upstream.conf -s reload
```

<br>

## Configs
### `main.conf`
```bash
user www-data;
worker_processes auto;
pid /run/main_nginx.pid;

events {
    worker_connections 768;
}

http {
    upstream foo {
        # server localhost:8888;
        server localhost:8888 max_conns=1;
        keepalive 1;
    }

    access_log /tmp/access_main.log;
    error_log /var/log/nginx/error_main.log;

    server {
        listen 80;

        location / {
            keepalive_timeout 3600s;
            proxy_pass http://foo;
            proxy_set_header Connection "";
            proxy_http_version 1.1;
            proxy_read_timeout 3600;
            proxy_send_timeout 3600;
            proxy_socket_keepalive on;
        }
    }
}
```

<br>

### `upstream.conf`
```bash
user www-data;
worker_processes auto;
pid /run/upstream_nginx.pid;

events {
    worker_connections 768;
}

http {
    access_log /tmp/access_upstream.log;
    error_log /var/log/nginx/error_upstream.log;

    server {
        listen 8888;

        location / {
            keepalive_timeout 3600s;
            return 200 'Hello, world!';
        }
    }
}
```

<br>


## `tcpdump`
```bash
tcpdump -i any 'tcp port 8888'
tcpdump -i any 'tcp port 80'
```

<br>

## `lsof`
```bash
lsof -t -nP -i4TCP@0.0.0.0:80
lsof -t -nP -i4TCP@0.0.0.0:8888
```

<br>

## Emulate clients using `nc`
```bash
nc localhost 80
GET / HTTP/1.1
Host: localhost
Connection: keep-alive
Keep-Alive: timeout=3600
<Enter>
```