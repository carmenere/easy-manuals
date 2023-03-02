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
Each stream entry consists of one or more field-value pairs, somewhat like a record or a Redis hash.
Commands that read the stream, such as XRANGE or XREAD, are guaranteed to return the fields and values exactly in the same order they were added by XADD.

<br>

## Commands
- `XADD key [<MAXLEN | MINID> [= | ~] N] <* | id> field value [field value ...]` appends the specified stream entry to the stream at the specified `key`.
  - `*` will generate a unique ID autmatically;
  - `id` **explicit ID** provided by client.
- `XTRIM key <MAXLEN | MINID> [= | ~] N` trims the stream `key` by evicting older entries (entries with lower IDs) if needed.
- `XDEL key id [id ...]` removes the specified entries by their `id` from a stream `key`, and returns the number of entries deleted.
- `XLEN key` returns the number of entries inside a stream `key`.
- `XRANGE key start end [COUNT count]` returns all entries belonging to interval [`start`, `end`] (both **inclusive**) from the stream `key`.
  - The `-` and `+` special IDs mean respectively the **minimum** ID possible and the **maximum** ID possible inside a stream.
- `XREAD [COUNT count] [BLOCK timeout] STREAMS key [key ...] id [id ...]` read data from *one* or *multiple* streams, only returning entries with an **ID greater** than the provided `id`.
  - `BLOCK timeout` turns `XREAD` into **blocking mode**. If `timeout = 0` it means **infinity** timeout.
    -  sometimes it's usefully to use the special ID `$` in **blocking mode** to receive **only new entries**, i.e., entries that are added to the stream starting from the moment we block. 

`XREAD` and `XRANGE` don't remove entries after they were read. To purge stream there are `XTRIM` or `XADD` in **trimming mode**.<br>

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

> **Note**:
> - `=` means **exact** and is used **by default**.
> - `~` means **almost exact**, it is **more efficient** variant.

<br>

### Examples
- `XTRIM mystream MAXLEN 1000` will trim the stream `mystream` to **exactly** the latest `1000` items.
- `XTRIM mystream MAXLEN ~ 1000` here `XTRIM` **admits bursts** and stream can contain more then `1000` items.
- `XTRIM mystream MINID 649085820` will evict entries that have an ID **lower** than `649085820-0` from stream `mystream`.

<br>

## Consumer Groups
### Basic
Every **Consumer Group** is got **isolated subset** of messages from the **same stream**, i.e., consider three consumers `C1`, `C2`, `C3` and a stream that contains the messages `1`, `2`, `3`, `4`, `5`, `6`, `7` then messages will be served according to the following diagram:
```bash
1 -> C1
2 -> C2
3 -> C3
4 -> C1
5 -> C2
6 -> C3
7 -> C1
```

<br>

Within a **consumer group**, a given **consumer** (that is, just a client consuming messages from the stream), has to identify with a unique **consumer name**. Which is just a string.

<br>

Redis **Consumer Groups** provide following guarantees:
1. It is **not possible** that the same message will be delivered to multiple consumers. Consumer can only see the history of messages that were delivered to it, so a message has just a single owner. However there is a special feature called **message claiming** that allows other consumers to **claim messages** in case there is a non recoverable failure of some consumer.
2. When a consumer asks for new messages it gets only new messages that were not previously delivered.
3. Consuming a message, however, requires an explicit acknowledgment using a specific command.
4. A **consumer group** tracks all the messages that are currently **pending**.

### Pending Entries List
**Pending Entries List** (**PEL**) is a list of messages delivered but not yet acknowledged.<br>
When client reads with `XREADGROUP`, the server will remember that a given message was delivered to client: the message will be stored inside the consumer group in **PEL**.
The client will have to acknowledge the message processing using `XACK` in order to remove message from **PEL**.<br>
The **PEL** can be inspected using the `XPENDING` command.<br>
The `NOACK` subcommand can be used to avoid adding the message to the **PEL** in cases where reliability is not a requirement and the occasional message loss is acceptable.

<br>

### Commands
- `XGROUP CREATE key group <id | $> [MKSTREAM] [ENTRIESREAD entries-read]` **creates** a new consumer group `group` for the stream `key`.
  - The command's `<id>` argument specifies the **starting ID** for the **consumer group**. If you want to fetch the entire stream from the beginning, use **zero** starting ID for the consumer group.
- `XGROUP DESTROY key group`  completely **destroys** a consumer group `group`, the consumer group will be destroyed **even** if there are **active consumers**, and **pending** messages.
- `XGROUP CREATECONSUMER key group consumer` explicitly **creates** a new consumer `consumer` in the consumer group `group` for the stream `key`.
  - consumers are also created **automatically** whenever an operation, such as `XREADGROUP`, references a *consumer* that **doesn't exist**.
- `XREADGROUP GROUP group consumer [COUNT count] [BLOCK milliseconds] [NOACK] STREAMS key [key ...] id [id ...]` is used to read from a stream **via a consumer group**.
  - `XREADGROUP` requires a special and mandatory option `GROUP <group-name> <consumer-name>`.
    - the **group** is created using the `XGROUP` command.
    - the **consumer name** is the string that is used by the client to identify itself inside the group. 
    - the **consumer** is auto created inside the consumer group the first time it is saw. Different clients should select a different consumer name.
  - The ID to specify in the `STREAMS` option when using `XREADGROUP` can be one of the following two:
    - The special `>` ID, which means that the consumer want to receive only new messages, i.e., messages that were never delivered to any other consumer.
    - Any valid ID. If the ID is not `>`, then the command will just let the client access its pending entries: messages delivered to it, but not yet acknowledged.
  - If client re-fetches the same message again, then the **last delivery counter** is updated to the current time, and the **number of deliveries** is incremented by one.
- `XACK` is the command that allows a consumer to mark a pending message as correctly processed.
- `XCLAIM key group consumer min-idle-time id` changes the owner of a pending message to `consumer`.
- `XPENDING mystream mygroup` outputs a summary about the pending messages in a given consumer group `mygroup` of the stream `mystream`.
- `XINFO CONSUMERS key group` returns the list of consumers that belong to the consumer group `mygroup` of the stream `mystream`.
  - The following information is provided **for each consumer** in the group:
    - **name**: the consumer's name;
    - **pending**: the number of pending messages for the **consumer**;
    - **idle**: the number of milliseconds that have passed since the consumer last interacted with the server.
- `XINFO GROUPS key` returns the list of **all consumers groups** of the stream stored at `key`.
  - the following information is provided for each of the groups:
    - **name**: the consumer group's name;
    - **consumers**: the number of consumers in the group;
    - **pending**: the length of the group's PEL;
    - **last-delivered-id**: the ID of the last entry delivered the group's consumers;
    - **entries-read**: the logical "read counter" of the last entry delivered to group's consumers;
    - **lag**: the number of entries in the stream that are still waiting to be delivered to the group's consumers, or a NULL when that number can't be determined.
- `XINFO STREAM key [FULL [COUNT count]]` returns information about the stream stored at `key`.

<br>

#### Examples
##### `XADD`, `XGROUP`, `XREADGROUP`
```bash
localhost:6379> FLUSHALL
OK
localhost:6379> XADD events * id 10
"1677778380263-0"
localhost:6379> XADD events * id 20
"1677778382038-0"
localhost:6379> XADD events * id 30
"1677778384391-0"


localhost:6379> XGROUP CREATE events G1 0
OK
localhost:6379> XREADGROUP GROUP G1 C1 COUNT 10 STREAMS events >
1) 1) "events"
   2) 1) 1) "1677778380263-0"
         2) 1) "id"
            2) "10"
      2) 1) "1677778382038-0"
         2) 1) "id"
            2) "20"
      3) 1) "1677778384391-0"
         2) 1) "id"
            2) "30"
localhost:6379> XREADGROUP GROUP G1 C1 COUNT 10 STREAMS events >
(nil)
localhost:6379> XREADGROUP GROUP G1 C1 COUNT 10 STREAMS events 0
1) 1) "events"
   2) 1) 1) "1677778380263-0"
         2) 1) "id"
            2) "10"
      2) 1) "1677778382038-0"
         2) 1) "id"
            2) "20"
      3) 1) "1677778384391-0"
         2) 1) "id"
            2) "30"

localhost:6379> XADD events * id 40
"1677781715318-0"
localhost:6379> XADD events * id 50
"1677781717310-0"
localhost:6379> XADD events * id 60
"1677781719647-0"

localhost:6379> XREAD STREAMS events 0
1) 1) "events"
   2) 1) 1) "1677778380263-0"
         2) 1) "id"
            2) "10"
      2) 1) "1677778382038-0"
         2) 1) "id"
            2) "20"
      3) 1) "1677778384391-0"
         2) 1) "id"
            2) "30"
      4) 1) "1677781715318-0"
         2) 1) "id"
            2) "40"
      5) 1) "1677781717310-0"
         2) 1) "id"
            2) "50"
      6) 1) "1677781719647-0"
         2) 1) "id"
            2) "60"

localhost:6379> XREADGROUP GROUP G1 C0 COUNT 1 STREAMS events >
1) 1) "events"
   2) 1) 1) "1677781715318-0"
         2) 1) "id"
            2) "40"

localhost:6379> XREADGROUP GROUP G1 C1 COUNT 1 STREAMS events >
1) 1) "events"
   2) 1) 1) "1677781717310-0"
         2) 1) "id"
            2) "50"

localhost:6379> XREADGROUP GROUP G1 C2 COUNT 1 STREAMS events >
1) 1) "events"
   2) 1) 1) "1677781719647-0"
         2) 1) "id"
            2) "60"
localhost:6379>

localhost:6379> XPENDING events G1
1) (integer) 6
2) "1677778380263-0"
3) "1677781719647-0"
4) 1) 1) "C0"
      2) "1"
   2) 1) "C1"
      2) "4"
   3) 1) "C2"
      2) "1"


localhost:6379> XREADGROUP GROUP G1 C2 STREAMS events 0
1) 1) "events"
   2) 1) 1) "1677781719647-0"
         2) 1) "id"
            2) "60"
localhost:6379> XREADGROUP GROUP G1 C1 STREAMS events 0
1) 1) "events"
   2) 1) 1) "1677778380263-0"
         2) 1) "id"
            2) "10"
      2) 1) "1677778382038-0"
         2) 1) "id"
            2) "20"
      3) 1) "1677778384391-0"
         2) 1) "id"
            2) "30"
      4) 1) "1677781717310-0"
         2) 1) "id"
            2) "50"
```

<br>

##### `XINFO`
```bash
localhost:6379> XINFO GROUPS events
1)  1) "name"
    2) "G1"
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

localhost:6379> XINFO CONSUMERS events G1
1) 1) "name"
   2) "C0"
   3) "pending"
   4) (integer) 1
   5) "idle"
   6) (integer) 713882
2) 1) "name"
   2) "C1"
   3) "pending"
   4) (integer) 4
   5) "idle"
   6) (integer) 432374
3) 1) "name"
   2) "C2"
   3) "pending"
   4) (integer) 1
   5) "idle"
   6) (integer) 436696

localhost:6379> XINFO STREAM events
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