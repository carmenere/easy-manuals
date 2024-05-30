# TCP/UDP
In linux for **every** UDP datagram kernel performs **route lookup**, because **UDP** has **no** session.<br>
**TCP** has sessions and stores information about **route** in session.<br>
So, **TCP** is **more efficient** on **large data** that are **more** than **MTU**.<br>

**QUIC** uses **UDP** as transport and has perfomance problems.<br>

<br>

# QUIC
**QUIC** is a **multiplexed** transport protocol built on **UDP**.<br>

**QUIC** is implemented in **userspace**, so its handshake also in userspace. Why? It has to be possible to deploy **QUIC** on any machine even without OS kernel support.<br>
Also **QUIC** has **problems** when **reordering** has happened.<br>

<br>

# SPDY -> HTTP/2

<br>

# HTTP/3
**HTTP/3** uses **QUIC**.

<br>

# WebSocket
The **WebSocket** protocol enables **full-duplex** communication between a **client** and a **server** over **TCP** connection.<br>
It uses own **binary frame-based protocol** protocol.<br>

<br>

# RPC
## XML-RPC and SOAP
Both **XML-RPC** and **SOAP** use **XML**.<br>

<br>

## JSON-RPC
The **JSON-RPC** uses **JSON**.<br>

<br>

## gRPC
**gRPC** is a **binary** protocol. It uses own serialization protocol **Protobuf** (aka **Protocol Buffers**).<br>
**gRPC** is based on **HTTP/2**.