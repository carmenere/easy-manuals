# Linux bridge
## Create
- `ip link add name ${BR_NAME} type bridge`;
- `ip link set ${BR_NAME} up`;

<br>

## Assigning an IP address to linux bridge
`ip addr add dev ${BR_NAME} 192.168.56.7/24`

<br>

## Add host iface to bridge
1. **Delete** address **before** add to bridge: `ip a del ${ADDR} dev ${ETH}`.
2. **Before** add **host interface** to bridge, enable promisc mode on it
`ip link set ${ETH} promisc on`
3. Add iface **eth**, **veth** ot **tap** iface: `ip link set ${ETH}|${VETH}|${TAP} master ${BR_NAME}`.

<br>

## Remove an interface from a bridge
`ip link set ${ETH} nomaster`

<br>

## Delete a bridge
1. `ip link set dev ${BR_NAME} down`
2. `ip link delete ${BR_NAME} type bridge`

<br>

# VETH
```bash
NS1=ns1
NS2=ns2

VETH1=veth0
VETH2=veth1
```

<br>

## Create namespaces
```bash
ip netns add ${NS1}
ip netns add ${NS2}
```

<br>

## Create veth pair
`ip link add ${VETH1} type veth peer name ${VETH2}`

<br>

## Put veth to particular namespaces
```bash
ip link set ${VETH1} netns ${NS1}
ip link set ${VETH2} netns ${NS2}
```

<br>

## Run command in NS
`ip netns exec ${NS1} ping 8.8.8.8`

<br>

## Delete NS
```bash
ip netns del ${NS1}
ip netns del ${NS2}
```

<br>

# VLAN sub-interface
## VARIANT 1
`ip link add link ${ETH} name ${ETH}.${VLAN_ID} type vlan id ${VLAN_ID}`

<br>

## VARIANT 2
`ip link add link ${ETH} name "vlan${VLAN_ID}" type vlan id ${VLAN_ID}`

<br>

# MACVLAN
## ENVs
```bash
PARENT_1=enp0s8
PARENT_2=enp0s8

SLAVE_1=macvlan0
SLAVE_2=macvlan1

NS1=ns1
NS2=ns2
```

<br>

## Create macvlan
```bash
ip link add ${SLAVE_1} link ${PARENT_1} type macvlan mode bridge
ip link add ${SLAVE_2} link ${PARENT_2} type macvlan mode bridge
```

<br>

## Create namespaces
```bash
ip netns add ${NS1}
ip netns add ${NS2}
```

<br>

## Activate promiscuous on Master
```bash
ip link set ${PARENT_1} promisc on
ip link set ${PARENT_2} promisc on
```

<br>

## Put MACVLAN SLAVEs interfaces to particular namespaces
```bash
ip link set ${SLAVE_1} netns ${NS1}
ip link set ${SLAVE_2} netns ${NS2}
```

<br>

## Up MACVLAN interfaces
```bash
ip netns exec ${NS1} ip link set ${SLAVE_1} up
ip netns exec ${NS2} ip link set ${SLAVE_2} up
```

<br>

## Assign IP addresses to macvlan interfaces
```bash
ip netns exec ${NS1} ip a add 192.168.56.10/24 dev ${SLAVE_1}
ip netns exec ${NS2} ip a add 192.168.56.20/24 dev ${SLAVE_2}
```

<br>

## Ping for test connectivity
```bash
ip netns exec ${NS1} ping 192.168.56.20
```

<br>

## Delete NS
```bash
ip netns del ${NS1}
ip netns del ${NS2}
```

<br>

# VXLAN
```bash
VXLAN=vx0
ETH=enp0s8

DPORT=5555

VNI=10000
LOCAL_IP=1.1.1.1
REMOTE_IP=2.2.2.2
```

## Create
`ip link add ${VXLAN} type vxlan id ${VNI} local ${LOCAL_IP} remote ${REMOTE_IP} dev ${ETH} dstport ${DPORT}`
