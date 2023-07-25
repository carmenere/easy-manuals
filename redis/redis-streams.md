# Redis Queue
There are 3 ways to use Redis as MQ:
|Approach|Fan-out|Guarantees|Persistance|
|:-------|:------|:---------|:----------|
|**Pub/Sub**|Yes|At-most-once|No|
|**Lists**|1-to-1|At-most-once|AOF, RDB|
|**Streams**|Yes|At-least-once, **Exactly-once** within **Consumer Group**|AOF, RDB|

<br>

## Pub/Sub
The **consumers** run ```SUBSCRIBE <channel> [<channel> ... ]``` or ```PSUBSCRIBE <channel.*> [<channel.*> ... ]``` command.<br>
The **publisher** runs ```PUBLISH <channel> <message>```.

<br>

> **Drawbacks**:
> - When a message is published, if the consumer doesn’t receive it right now, the message disappears.
> - All messages are gone away if Redis is shutdown.

<br>

## Lists
The **publisher** run ```RPUSH <key> <message>``` command.<br>
The **consumers** runs ```LPOP <key> <count>``` or ```BLPOP <key> <timeout>```. ```BLPOP``` is used to wait for a message in blocking mode.<br>
If consumer read message with ```BLPOP``` it means others consumers will not see this message.

<br>

# Redis Streams
## Basics
**The Redis stream** is data type.<br>
Streams are an **append-only** data structures.<br>
Each **stream entry** consists of a **set** of *one* or *more* **field-value pairs**.<br>
Stream entries are also strictly ordered over an **ID**, which must be **unique**, and which is made up of 2 numbers separated by a `-` character, consisting of a **timestamp** and a **sequence number**, e.g. `555555555-1`, `444444444-2`, etc.<br>
Commands that read the stream, such as `XREADGROUP`, `XRANGE` or `XREAD`, are guaranteed to return the fields and values exactly in the same order they were added by `XADD`.

<br>

Redis Streams support two types of consumers: 
- **individual consumers**;
- **consumer groups**.

<br>

Both styles can be used **simultaneously** on **the same** streams.

<br>

## Commands
- `XADD mystream [<MAXLEN | MINID> [= | ~] N] <* | id> field value [field value ...]` appends the specified stream entry to the stream at the specified `mystream`.
  - The special ID character `*` will generate a unique ID automatically;
  - `id` is an **explicit ID** provided by client, it is only really useful if you can rely on another definitive source of strictly increasing IDs.
- `XTRIM mystream <MAXLEN | MINID> [= | ~] N` trims the stream `mystream` by evicting older entries (entries with lower IDs) if needed.
- `XDEL mystream id [id ...]` removes the specified entries by their `id` from a stream `mystream`, and returns the number of entries deleted.
- `XLEN mystream` returns the number of entries inside a stream `mystream`.
- `XRANGE mystream start end [COUNT count]` returns all entries belonging to interval [`start`, `end`] (both **inclusive** by default) from the stream `mystream`.
  - The special ID character `-` means the **minimum** possible ID inside a stream;
  - The special ID character `+` means the **maximum** possible ID inside a stream;
- `XREVRANGE` is exactly like `XRANGE`, but returns entries in **reverse order**.
- `XREAD [COUNT count] [BLOCK timeout] STREAMS mystream [mystream-2 ...] id [id ...]` read data from *one* or *more* streams, only returning entries with an IDs **greater** than the provided `id`.
  - `XREAD` returns with any entries currently available (up to the `COUNT`), or none at all.
  - `BLOCK timeout` turns `XREAD` into **blocking mode**, if `timeout = 0` it means **infinity** timeout.
  - The special ID character `$` tells Redis Streams **retrieve only new entries**, and it should only be used as the first call to `XREAD` by a consumer on a given stream. Otherwise, if you use it again you could potentially miss entries that were added between polls.

<br>

### Iterating a stream
In order to **iterate a stream**, we start fetching the first **N** elements, which is trivial:
```bash
XRANGE writers - + COUNT N
```
and then instead of `-` character we use the ID of the **last entry** (e.g., "1526985685298-0") returned by the previous `XRANGE` call and prefix it with `(` (**exclusive interval**):
```bash
XRANGE writers (1526985685298-0 + COUNT 2
```

<br>

> **Note**<br>
> `XREAD` and `XRANGE` **don't** remove entries from stream after they were read.<br>
> To **purge** stream use `XTRIM` or `XADD` commands in **trimming mode**.<br>

<br>

So, in summary, Redis Streams `XREAD` relies on consumers remembering the ID of the latest entry they received.<br>
If something goes wrong, the best they can do is start reading from the newest entries again, or if they support idempotent operations, reading from further back (e.g. some time back if they can estimate their recovery time), or even from the beginning all over again (ID **0-0** or **0**).<br>
So, Redis Streams with `XREAD` puts most of the effort of remembering IDs onto the consumer.

<br>

### Examples
- `XREAD COUNT 50 STREAMS mystream 0`
- `XREAD COUNT 2 STREAMS mystream writers 0 0`
- `XRANGE somestream - +`

<br>

## Stream entry ID
A **stream entry ID** identifies a given entry inside a stream and has format `{MillisecondsTime}-{SequenceNumber}`:
- the **first part** is the Unix time in **milliseconds** of the Redis instance generating the ID. 
- the **second part** is just a **sequence number** and is used in order to distinguish IDs generated in the same millisecond.

You can also specify **only** *first part*, Redis will add **zero** for *second part*.<br>

Requirements for **explicit ID**:
- the **minimum** valid ID is `0-1`;
- it must be **greater** than **any** other ID currently inside the stream, otherwise the `XADD` will **fail** and return an **error**.

<br>

## Capped streams
`XADD` and `XTRIM` commands are for sreams **capping**:
- `XTRIM` performs *on demand* **capping**. 
- `XADD` adding new entries and keeping the stream's size in check at once.

<br>

Both `XTRIM` and `XADD` have 2 **trimming strategy**:
- `MAXLEN`
- `MINID`

<br>

> **Note**<br>
> - `=` means **exact** and is used **by default**.
> - `~` means **almost exact**, it is **more efficient** variant.


### Examples
- `XTRIM mystream MAXLEN 1000` will trim the stream `mystream` to **exactly** the latest `1000` items.
- `XTRIM mystream MAXLEN ~ 1000` here `XTRIM` **admits bursts** and stream can contain more then `1000` items.
- `XTRIM mystream MINID 649085820` will evict entries that have an ID **lower** than `649085820-0` from stream `mystream`.

<br>

## Consumer Groups
### Basic
Every **Consumer Group** is got **isolated subset** of messages from the **same stream**, i.e., consider three consumers `worker-2`, `worker-3`, `C3` and a stream that contains the messages `1`, `2`, `3`, `4`, `5`, `6`, `7` then messages will be served according to the following diagram:
```bash
1 -> worker-2
2 -> worker-3
3 -> C3
4 -> worker-2
5 -> worker-3
6 -> C3
7 -> worker-2
```

<br>

Every **consumer** (a client consuming messages from the stream) **in the group** must have a **unique name**, which is just a string.

<br>

Redis **Consumer Groups** provide following guarantees:
1. It is **not possible** that the same message will be delivered to multiple consumers. Consumer can only see the history of messages that were delivered to it, so a message has just a single owner. However there is a special feature called **message claiming** that allows other consumers to **claim messages** in case there is a non recoverable failure of some consumer.
2. When a consumer asks for new messages it gets only new messages that were not previously delivered.
3. Consuming a message, however, requires an explicit acknowledgment using a specific command.
4. A **consumer group** tracks all the messages that are currently **pending**.

<br>

### Pending Entries List
**Pending Entries List** (**PEL**) is a list of messages delivered but not yet acknowledged.<br>
When client reads with `XREADGROUP`, the server will remember that a given message was delivered to client: the message will be stored inside the consumer group in **PEL**.
The client will have to acknowledge the message processing using `XACK` in order to remove message from **PEL**.<br>
The **PEL** can be inspected using the `XPENDING` command.<br>
The `NOACK` subcommand can be used to avoid adding the message to the **PEL** in cases where reliability is not a requirement and the occasional message loss is acceptable.

<br>

### Commands
- `XGROUP CREATE mystream group {id | $} [MKSTREAM] [ENTRIESREAD entries-read]` **creates** a new consumer group `group` for the stream `mystream`.
  - The command's `{id | $}` argument specifies the **starting ID** for the **consumer group**.
    - if you want to fetch the **entire stream** from the beginning, use zero ID `0`;
    - if you want to fetch **only new** messages use the special ID character `$`.
  - `MKSTREAM` create **empty** stream `mystream` if it doesn't exist. By default, `XGROUP CREATE mystream` returns error if stream `mystream` doesn't exist.
- `XREADGROUP GROUP group consumer [COUNT count] [BLOCK milliseconds] [NOACK] STREAMS mystream [mystream-2 ...] {id | >} [id ...]` provides the **consumer group** functionality, but first, you have to create a *consumer group* using the `XGROUP CREATE` command. This command returns entries with an IDs **greater** than the provided `id`.
  - The `XREADGROUP` command **requires** the `GROUP` keyword followed by the *group name*, and the *consumer name*. 
  - The `STREAMS` keyword is **required** and is followed by *one* or *more* streams to subscribe to, and the **starting ID** to read from for each stream.
  - The special ID character `>` means that the consumer want to **receive only new messages**, i.e., messages that were never delivered to any other consumer.
  - The explicit ID `id` is for accessing consumer's **pending entries**: messages delivered to it, but not yet acknowledged.
  - If client re-fetches the same message again, then the **last delivery timestamp** is updated to the current time, and the **number of deliveries** is incremented by one.
- `XGROUP DESTROY mystream group`  completely **destroys** a consumer group `group`, the consumer group will be destroyed **even** if there are **active consumers**, and **pending** messages.
- `XGROUP CREATECONSUMER mystream group consumer` explicitly **creates** a new consumer `consumer` in the consumer group `group` for the stream `mystream`.
  - consumers are also created **automatically** whenever an operation, such as `XREADGROUP`, references a *consumer* that **doesn't exist**.
- `XACK` is the command that allows a consumer to mark a pending message as correctly processed.
- `XCLAIM mystream mygroup new-consumer min-idle-time id` changes the owner of a pending message to `consumer`.
- `XPENDING mystream mygroup` outputs a summary about the pending messages in a given consumer group `mygroup` of the stream `mystream`. It outputs:
  - the **total number** of pending messages for given consumer group;
  - the **smallest** ID and **greatest** ID among the pending messages;
  - **list of consumers** in the consumer group `mygroup` with at least one pending message, and the **number of pending messages per consumer**.
- `XINFO STREAM mystream [FULL [COUNT count]]` returns information about the stream stored at `mystream`.
- `XINFO GROUPS mystream` returns the list of **all consumers groups** of the stream stored at `mystream`.
  - the following information is provided for each of the groups:
    - **name**: the consumer group's name;
    - **consumers**: the number of consumers in the group;
    - **pending**: the length of the group's PEL;
    - **last-delivered-id**: the ID of the last entry delivered the group's consumers;
- `XINFO CONSUMERS mystream mygroup` returns the list of consumers that belong to the consumer group `mygroup` of the stream `mystream`.
  - The following information is provided **for each consumer** in the group:
    - **name**: the consumer's name;
    - **pending**: the number of pending messages for the **consumer**;
    - **idle**: the number of milliseconds that have passed since the consumer last interacted with the server.

<br>

### Extended form of `XPENDING`
Sometimes we are interested in the details. In order to see all the pending messages with more associated information we need to also pass a **range of IDs** and a **count argument**, to limit the number of messages returned per call:

```bash
localhost:6379> XPENDING mystream mygroup - + 10
1) 1) "1690275395539-0"
   2) "worker-2"
   3) (integer) 6011030
   4) (integer) 1
2) 1) "1690275399380-0"
   2) "worker-2" 
   3) (integer) 242423 
   4) (integer) 1
3) 1) "1690275401378-0"
   2) "worker-2" 
   3) (integer) 240579 
   4) (integer) 1
4) 1) "1690275403409-0"
   2) "worker-1" 
   3) (integer) 231842 
   4) (integer) 1
5) 1) "1690275405944-0"
   2) "worker-1" 
   3) (integer) 230851 
   4) (integer) 1
localhost:6379>
```

<br>

**Filter by particular consumer** and/or **idle time**:<br>
```bash
localhost:6379> XPENDING mystream mygroup - + 10 worker-1
1) 1) "1690275403409-0"
   1) "worker-1"
   2) (integer) 1116605
   3) (integer) 1
2) 1) "1690275405944-0"
   1) "worker-1"
   2) (integer) 1115614
   3) (integer) 1
localhost:6379>
```

<br>

```bash
localhost:6379> XPENDING mystream mygroup IDLE 9000 - + 10 worker-1
1) 1) "1690275403409-0"
   1) "worker-1"
   2) (integer) 1116605
   3) (integer) 1
2) 1) "1690275405944-0"
   1) "worker-1"
   2) (integer) 1115614
   3) (integer) 1
localhost:6379>
```

<br>

There is detailed information for each message in the PEL in the **extended form**. For each message **4** attributes are returned:
- the **ID** of the message;
- the **name of the consumer** that fetched the message and has still to acknowledge it. We call it the **current owner** of the message;
- the **idle time**. It is the **number of milliseconds** that elapsed since the last time this message was delivered to this consumer;
- the **deliveries counter**. The **deliveries counter** is incremented when some other consumer **claims** the message with `XCLAIM`, or when the message is **delivered again** via `XREADGROUP` with explicit ID.

<br>

#### Examples
##### `XADD`, `XGROUP`, `XREADGROUP`
```bash
localhost:6379> FLUSHALL
OK
localhost:6379> XADD mystream * id 10
"1677778380263-0"
localhost:6379> XADD mystream * id 20
"1677778382038-0"
localhost:6379> XADD mystream * id 30
"1677778384391-0"


localhost:6379> XGROUP CREATE mystream mygroup $ MKSTREAM
OK

localhost:6379> XADD mystream * id 10
"1690275391705-0"
localhost:6379> XADD mystream * id 20
"1690275395539-0"
localhost:6379> XADD mystream * id 30
"1690275399380-0"
localhost:6379> XADD mystream * id 40
"1690275401378-0"
localhost:6379> XADD mystream * id 50
"1690275403409-0"
localhost:6379> XADD mystream * id 60
"1690275405944-0"
localhost:6379> XADD mystream * id 70
"1690275410409-0"
localhost:6379> XADD mystream * id 80
"1690275412737-0"

# Explicit ID is used to fetch messages that are in PEL, worker-1 didn't read any at the moment
localhost:6379> XREADGROUP GROUP mygroup worker-1 COUNT 1 STREAMS mystream 0
1) 1) "mystream"
   2) (empty array)

# Special ID '>' is used to fetch NEW messages from stream, COUNT 1 means read only 1 message
localhost:6379> XREADGROUP GROUP mygroup worker-1 COUNT 1 STREAMS mystream >
1) 1) "mystream"
   2) 1) 1) "1690275391705-0"
         2) 1) "id"
            2) "10"

localhost:6379> XREADGROUP GROUP mygroup worker-2 COUNT 1 STREAMS mystream >
1) 1) "mystream"
   2) 1) 1) "1690275395539-0"
         2) 1) "id"
            2) "20"

localhost:6379> XPENDING mystream mygroup
1) (integer) 2
2) "1690275391705-0"
3) "1690275395539-0"
4) 1) 1) "worker-1"
      2) "1"
   2) 1) "worker-2"
      2) "1"

# Consumer worker-1 confirms message 1690275391705-0 
localhost:6379> XACK mystream mygroup "1690275391705-0"
(integer) 1

localhost:6379> XACK mystream mygroup "1690275391705-0"
(integer) 0

localhost:6379> XPENDING mystream mygroup
1) (integer) 1
2) "1690275395539-0"
3) "1690275395539-0"
4) 1) 1) "worker-2"
      2) "1"

# here we read mesasges by worker-1 and worker-2

localhost:6379> XREADGROUP GROUP mygroup worker-1 STREAMS mystream "0-0"
1) 1) "mystream"
   2) 1) 1) "1690275403409-0"
         2) 1) "id"
            2) "50"
      2) 1) "1690275405944-0"
         2) 1) "id"
            2) "60"
      3) 1) "1690275410409-0"
         2) 1) "id"
            2) "70"
      4) 1) "1690275412737-0"
         2) 1) "id"
            2) "80"
localhost:6379>
```

<br>

Number of pending messages **before** `XCLAIM` command:<br>
```bash
localhost:6379> XINFO GROUPS mystream
1) 1) "name"
   2) "mygroup"
   3) "consumers"
   4) (integer) 2
   5) "pending"
   6) (integer) 7
   7) "last-delivered-id"
   8) "1690275412737-0"
localhost:6379>
```

<br>

```bash
localhost:6379> XCLAIM mystream mygroup worker-3 1000 "1690275403409-0" "1690275405944-0"
1) 1) "1690275403409-0"
   2) 1) "id"
      2) "50"
2) 1) "1690275405944-0"
   2) 1) "id"
      2) "60"
localhost:6379>
```

<br>

Number of pending messages **wasn't** changed **after** `XCLAIM` command:<br>
```bash
localhost:6379> XINFO GROUPS mystream
1) 1) "name"
   2) "mygroup"
   3) "consumers"
   4) (integer) 3
   5) "pending"
   6) (integer) 7
   7) "last-delivered-id"
   8) "1690275412737-0"
localhost:6379>
```

<br>

##### `XINFO`
```bash
localhost:6379> XINFO GROUPS mystream
1)  1) "name"
    2) "mygroup"
    3) "consumers"
    4) (integer) 3
    5) "pending"
    6) (integer) 6
    7) "last-delivered-id"
    8) "1677781719647-0"
    9) "entries-read"
   10) (integer) 6
   11) "lag"
   12) (integer) 0

localhost:6379> XINFO CONSUMERS mystream mygroup
1) 1) "name"
   2) "worker-1"
   3) "pending"
   4) (integer) 1
   5) "idle"
   6) (integer) 713882
2) 1) "name"
   2) "worker-2"
   3) "pending"
   4) (integer) 4
   5) "idle"
   6) (integer) 432374
3) 1) "name"
   2) "worker-3"
   3) "pending"
   4) (integer) 1
   5) "idle"
   6) (integer) 436696

localhost:6379> XINFO STREAM mystream
 1) "length"
 2) (integer) 6
 3) "radix-tree-keys"
 4) (integer) 1
 5) "radix-tree-nodes"
 6) (integer) 2
 7) "last-generated-id"
 8) "1677781719647-0"
 9) "max-deleted-entry-id"
10) "0-0"
11) "entries-added"
12) (integer) 6
13) "recorded-first-entry-id"
14) "1677778380263-0"
15) "groups"
16) (integer) 1
17) "first-entry"
18) 1) "1677778380263-0"
    2) 1) "id"
       2) "10"
19) "last-entry"
20) 1) "1677781719647-0"
    2) 1) "id"
       2) "60"
localhost:6379>
```