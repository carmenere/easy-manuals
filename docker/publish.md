# Differences between expose and publish
**Exposed ports** can only be accessed **internally**, **published ports** can be accessible by **external** containers and services.  

<br>

## Exposing
There are **2 ways** of **exposing** ports in Docker:
- via `EXPOSE <PORT>` instruction in the **Dockerfile**;
- via `–-expose=<port>` flag at runtime;

<br>

## Publishing
By default, when you **create** or **run** a container using `docker create` or `docker run`, the container **doesn't** publish any of its ports to the outside world.<br>

There are **2 ways** of **publishing** ports in Docker:
- using the `-P` or `–-publish-all` flag;
- using the `-p <host_ip:host_port:port_inside_container/protocol>` flag;

<br>

Using the `-P` flag at runtime lets you publish **all exposed** ports to **random ports on the host** interfaces.<br>

Notation for `--publish` or `-p` flag:
|Flag|Description|
|:---|:----------|
|`-p 8080:80`|Map `TCP` port `80` **inside the container** to port `8080` **on the Docker host**.|
|`-p 192.168.1.100:8080:80`|Map `TCP` port `80` **inside the container** to port `8080` **on the Docker host** for connections to **host IP** `192.168.1.100`.|
|`-p 8080:80/udp`|Map `UDP` port `80` **inside the container** to port `8080` **on the Docker host**.|
|`-p 8080:80/tcp -p 8080:80/udp`|Map `TCP` port `80` **inside the container** to `TCP` port `8080` **on the Docker host**, and map `UDP` port `80` **inside the container** to `UDP` port `8080` **on the Docker host**.|

<br>

**The Docker host** and **all hosts within the same L2 segment** (for example, hosts connected to the same network switch) **can reach** ports **published** to `localhost` (`127.0.0.1`).