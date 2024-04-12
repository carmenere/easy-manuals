# Proxying
Every client establishes **independent session** to proxy.<br>
Every **client's session** is uniquely determined by **five-typle** `(srcIP, dstIP, srcPort, dstPort, Protocol)` and gets some unique **cfd** (client's session fd) inside proxy runtime.<br>
For every client's session proxy establishes new session **to** appropriate **upstream** and it also gets some unique **ufd** (upstream's session fd) inside proxy runtime.

<br>

Consider example:
![Proxying](/img/proxying-1.png)

<br>

Client's sessions:
|srcIP|dstIP|srcPort|dstPort|Protocol|cfd|
|:----|:----|:------|:------|:-------|:--|
|localhost|localhost|80|44370|tcp|100|
|localhost|localhost|80|57668|tcp|200|
|localhost|localhost|80|58122|tcp|300|

<br>

Sessions to upstream:
|srcIP|dstIP|srcPort|dstPort|Protocol|ufd|
|:----|:----|:------|:------|:-------|:--|
|localhost|localhost|33328|8888|tcp|501|
|localhost|localhost|33329|8888|tcp|502|
|localhost|localhost|33330|8888|tcp|503|

<br>

So, **proxy maintains mapping between fds**: `(cfd, ufd)`. Every **cfd** *unambiguously corresponds to* **ufd** and *vice versa*:
|cfd|ufd|
|:--|:--|
|**100**|**501**|
|**200**|**502**|
|**300**|**503**|

<br>

All data proxy reads from **cfd** it then writes to **ufd** and respectively all data proxy reads from **ufd** it then writes to **cfd**:
![Read-Write](/img/proxying-2.png)

<br>

# Multiplexing
**Multiplexing** is reading responses from clients and writing them in **one upstream's session**.<br>
**Demultiplexing** is reading responses from **one upstream's session** and sending them to appropriate clients.<br>

<br>

Consider example:
![Multiplexing](/img/multiplexing-1.png)

<br>

Client's sessions:
|srcIP|dstIP|srcPort|dstPort|Protocol|cfd|
|:----|:----|:------|:------|:-------|:--|
|localhost|localhost|80|44370|tcp|100|
|localhost|localhost|80|57668|tcp|200|
|localhost|localhost|80|58122|tcp|300|

<br>

One session to upstream:
|srcIP|dstIP|srcPort|dstPort|Protocol|ufd|
|:----|:----|:------|:------|:-------|:--|
|localhost|localhost|33328|8888|tcp|501|

<br>

It is easy to map all ingress client's session to one upstream's session but there is no way unambiguously map responses to clients:
![Multiplexing](/img/multiplexing-2.png)

<br>

One possible solution is to queue requests from clients:
1. Take next request from **queue**.
2. Send it to upstream.
3. Wait response from upstream.
4. Step 1.

<br>

# Support for multiplexing in various protocols
|Protocol|Current status|RFC|Drawbacks|
|:-------|:-------------|:--|:-------|
|`WebSocket`|**Draft**|[draft](https://datatracker.ietf.org/doc/html/draft-ietf-hybi-websocket-multiplexing)||
|`HTTP/1.1`|**No support**||
|`HTTP/2`|**By design**|[rfc9113](https://datatracker.ietf.org/doc/html/rfc9113#name-streams-and-multiplexing)|**Not** all *libraries* or *server* alows `H2C` mode.|

<br>

`HTTP/2` modes:
- `H2` requires TLS
- `H2C` here **C** means **Cleartext**