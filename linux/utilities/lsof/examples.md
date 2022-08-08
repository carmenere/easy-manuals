
### **Example 1**.
Parametrized version. Lists all file descriptors and PIDs that bound to specific socket `${LOCAL_ADDRESS}`:`${LOCAL_PORT}` of L4 protocol `${L4_PROTO}` and L3 protocol `${L3_PROTO}` and L4 protocol state `${L4_PROTO_STATE}`.

```bash
lsof -nP -i${L3_PROTO}${L4_PROTO}@${LOCAL_ADDRESS}:${LOCAL_PORT} -s${L4_PROTO}:${L4_PROTO_STATE}
```

<br>

### **Example 2**.
```bash
# IPv4
L3_PROTO="4"
L4_PROTO="TCP"
LOCAL_ADDRESS="0.0.0.0"
LOCAL_PORT="8081"
L4_PROTO_STATE="LISTEN"
```

```bash
lsof -nP -i4TCP:8081 -sTCP:LISTEN
```

<br>

### **Example 3**.

The same as the [Example 2](#example-2), with the difference that **only** PIDs are displayed: option `-t`.

```bash
lsof -t -nP -i4TCP:8081 -sTCP:LISTEN
```