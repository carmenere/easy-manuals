# tcpdump
## Field `Flags[]`
- `[S]` only `SYN` flag
- `[F]` only `FIN` flag
- `[R]` only `RST` flag
- `[P]` only `PSH` flag
- `[.]` only `ACK` flag, none of `SYN`, `FIN`, `RST` and `PSH` flags is **not** set
- `[S.]` only `SYN` and `ACK` flags 
- `[F.]` only `FIN` and `ACK` flags
- `[P.]` only `PSH` and `ACK` flags
- `[R.]` only `RST` and `ACK` flags

<br>

If flag `ACK` is set tcpdump will print out value of **filed** `ack`.
If flag `URG` is set tcpdump will print out value of **filed** `urg`.

<br>

Examples:
- `Flags [S], seq 3026561541, win 14600` it is `SYN` segment;
- `Flags [S.], seq 4182060275, ack 3026561542, win 5792` it is `SYN`,`ACK` segment;
- `Flags [.], ack 4182060276, win 913` it is `ACK` segment;
- `Flags [F.]` it is `FIN` segment;
- `Flags [P.]` it is `PSH` segment;

<br>

# tcpdump options
- `-D` list **available interfaces**
- `-A` print **frame payload** in **ASCII**
- `-x` print **frame payload** in **hex**
- `-X` print **frame payload** in **hex and ASCII**
- `-S` print **absolute** TCP sequence numbers; **by default** tcpdump prints **relative** sequence numbers started at **0**
- `-с count` exit after capturing `count` packets
- `-s len` capture up to `len` bytes per packet; **by default**: `68`
- `-i interface` specifies the **capture interface**; **by default**: `eth0`; examples: `any`, `lo`, `tun0`, `wlan0`
- `-n` **don't resolve addresses to names**
- `-e` print **link-level  headers**
- `-F file` use filter expression from `file`
- `-t` don't print timestamps
- `-q` quick output (**minimum information**)
- `-v[v[v]]` print **more verbose output**
- `-w path` **write captured packets to file**
- `-r path` read packets from file (file must be saved with option -w)
- `-K` don't verify TCP checksums
- `-G n` rotate the dump file every n seconds

<br>

# tcpdump filter expression
**Logic operators** for complex expressions: 
- `and`/`&&`
- `or`/`||` 
- `not`/`!`

<br>

There are **parenthesis** to change priority of logic operators. To use **parenthesis** **whole expression** must be enclosed in **single quotes** `'...'` or **parentheses** must be preceded by a **backslash** `\( ...\)`.<br>

There are 2 type of syntax for filter expressions.<br>

## First syntax
`protocol` `direction` `type` `value`<br>

- `protocol` possible values are `ip`, `ip6`, `arp`, `tcp`, `udp`
- `direction` possible values are `src`, `dst`, `src or dst`, `src and dst`; by default `src or dst`
- `type` possible values are `host`, `net`, `port`, `portrange`; by default `host`
- `value`

<br>

**Examples**:
- `tcpdump -Stn -i any 'dst host 10.254.7.233'`
- `tcpdump -Stn -i any 'host 10.254.7.233'`
- `tcpdump -Stn -i any 'ip dst host 10.254.7.233'`
- `tcpdump -Stn -i any 'ip host 10.254.7.233'`
- `tcpdump -Stn -i any 'ip dst 10.254.7.233'`
- `tcpdump -Stn -i any 'tcp port 10' `
- `tcpdump -Stn -i any 'tcp dst port 10'`
- `tcpdump -Stn -i any 'tcp port 10'`
- `tcpdump -Stn -i any 'dst port 10'`
- `tcpdump -Stn -i any 'port 10'`
- `tcpdump -Stn -i any 'arp host 10.254.7.1'`
- `tcpdump -Stn -i any 'arp dst host 10.254.7.1'`
- `tcpdump -i wlan0 'src 192.168.10.100  &&  tcp port 80'`

<br>

## Second syntax
`protocol[offset:size]&mask == value` or `protocol[offset:size]&mask != value`<br>

- `protocol` possible values are `ip`, `ip6`, `arp`, `tcp`, `udp`
- `offset` **index** of byte
- `size` **number** of bytes to analyze; possible values are `1`, `2`, `4`; by default `1`
- `&mask` it is **optional**, filters bits that **must be set** in the analyzed field;
  - mask `01000000` captures bytes that have **6th bit set**: `01000000`, `01000001`, `01111111`, but doesn't capture `00000011`.

<br>

**TCP flags**:
|`7`|`6`|`5`|`4`|`3`|`2`|`1`|`0`|
|:-|:-|:-|:-|:-|:-|:-|:-|
|`CWR`|`ECE`|`URG`|`ACK`|`PSH`|`RST`|`SYN`|`FIN`|
|`2^7`|`2^6`|`2^5`|`2^4`|`2^3`|`2^2`|`2^1`|`2^0`|
|`128`|`64`|`32`|`16`|`8`|`4`|`2`|`1`|

<br>

**Examples**:
- `'tcp[13]==32'` **only** `URG` must be set (`32` => `00100000`)
- `'tcp[13]==16'` **only** `ACK` must be set (`16` => `00010000`)
- `'tcp[13]==8'` **only** `PSH` must be set (`8` => `00001000`)
- `'tcp[13]==4'` **only** `RST` must be set (`4` => `00000100`)
- `'tcp[13]==2'` **only** `SYN` must be set (`2` => `00000010`)
- `'tcp[13]==1'` **only** `FIN` must be set (`1` => `00000001`)
- `'tcp[13]&2==2'` bit `SYN` **must be set**, but other bits can be **set** or **not**
- `'tcp[13]&2!=0'` bit `SYN` **mustn't** be set, but other bits can be **set** or **not**
- `'tcp[13]==2 or tcp[13]==16'` bit `SYN` must be set **OR** bit `ACK` must be set, but other bits can be **set** or **not**
- `'tcp[13]&18 == 18'`	bit `SYN` must be set **AND** bit `ACK` must be set, but other bits can be **set** or **not**

<br>

# Examples
- `tcpdump -n -i any '(host 213.180.193.215) && (tcp[13] == 2 or tcp[13] == 18)' `
- `tcpdump -n -i any 'icmp[icmptype] == icmp-echo && icmp[icmptype]==icmp-echoreply'`
