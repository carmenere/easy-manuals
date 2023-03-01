**Redis** is the contraction from  **RE**mote **DI**ctionary **S**erver.<br>

# Redis data types
Every data type has its own commands.<br>
<br>




## Strings
### Overview
The **Redis String type** stores sequences of bytes, including *text* or *serialized objects*, from a string like *foo* to the *content of a JPEG file*.<br>
**Strings** in Redis are **binary safe**, meaning they have a **known length** *not determined* by any special terminating characters.<br>

### Limits
The **maximum** allowed key size is **512 MB**.<br>

### Basic commands
- `SET key value [NX | XX] [GET] [EX seconds | PX milliseconds | EXAT unix-time-seconds | PXAT unix-time-milliseconds | KEEPTTL]` sets `key` to hold the string `value`.
- `GET key` retrieves value of key `key`.
- `INCR key` increments the number stored at `key` by one.
- `DECR key` decrements the number stored at `key` by one.
- `INCRBY key increment` increments the number stored at `key` by `increment`.
- `DECRBY key decrement` decrements the number stored at `key` by `increment`.
- `APPEND key value` if `key` already exists and is a string, this command **appends** the `value` **at the end** of the string.
- `STRLEN key` returns the **length of the string** value stored at `key` or `0` when `key` **does not exist**. An error is returned when key holds a non-string value.
- `GETRANGE key start end` returns the **substring** of the string value stored at `key`, determined by the offsets `start` and `end` (both are **inclusive**).
- `SETRANGE key offset value` **overwrites** part of the string stored at `key`, starting at the specified `offset` by `value`.

<br>

`SET`:
- If key `key` already holds a value, it is **overwritten**, **regardless** *of its type*.<br>
- Any previous TTL associated with the key is discarded on successful `SET` operation.<br>
- Options:
  - `EX seconds` sets the specified expire time, in seconds.
  - `PX milliseconds` sets the specified expire time, in milliseconds.
  - `EXAT timestamp-seconds` sets the specified Unix time at which the key will expire, in seconds.
  - `PXAT timestamp-milliseconds` sets the specified Unix time at which the key will expire, in milliseconds.
  - `NX` sets the key only if it **does not** already exists.
  - `XX` sets the key only if it **already** exists.
  - `KEEPTTL` **retain** the TTL associated with the key.
  - `GET` return the old string stored at key, or `nil` if key did not exist. An error is returned and SET aborted if the value stored at key is not a string.

<br>

`GET`:
- If the key does not exist the special value `nil` is returned.
- An **error** is returned if the value stored at key is **not a string**, because GET only handles string values.

<br>

`INCR`, `DECR`, `INCRBY`, `DECRBY`:
- Redis does not have a dedicated integer type, so `INCR*` and `DECR*` operations interprets strings stored at the `key` as **64 bit signed integer** to execute the operation.


<br>

#### Examples
```bash
127.0.0.1:6379> SET prefix:1:name msk-01
OK
127.0.0.1:6379> SET prefix:1:value 1.1.1.1/32
OK

127.0.0.1:6379> GET prefix:1:name
"msk-01"
127.0.0.1:6379> GET prefix:1:value
"1.1.1.1/32"
```

<br>

## Keys
### Overview
**Keys** in Redis are of **Redis String type**. Since **Keys** are **Strings**, when we use the *string type* as a value too, we are mapping a *string* to another *string*.<br>
Rules about **keys**:
- Very long keys are **not** a good idea.
- Very short keys are often **not** a good idea.
- For instance, format `object-type:id:field` is a **good** idea.

<br>

### Basic commands
- `RENAME key newkey` renames `key` to `newkey`, it returns an **error** when `key` **does not exist**.
- `EXISTS key [key ...]` returns the **number of keys that exist** from those specified as arguments.
- `TTL key` returns:
  - TTL in seconds for key `key`.
  - `-2` if the `key` **does not exist**.
  - `-1` if the `key` **exists** but **has no** *associated expire*.
- `EXPIRE key seconds [NX | XX | GT | LT]` sets a **timeout** on `key`, returns:
  - `1` if the timeout was set.
  - `0` if the timeout was not set. e.g. `key` doesn't exist
- `PERSIST key` remove the existing timeout on `key`, turning the `key` from **volatile** to **persistent**, returns:
  - `1` if the timeout was removed.
  - `0` if `key` does not exist or does not have an associated timeout.


**Notes**:
- After the timeout has expired, the key `key` will automatically be deleted. 
- A key with an **associated timeout** is often said to be **volatile** in Redis terminology.

<br>

#### Examples
```bash
127.0.0.1:6379> RENAME prefix:1:value prefix:1:val
OK
127.0.0.1:6379> GET prefix:1:val
"1.1.1.1/32"
127.0.0.1:6379> GET prefix:1:value
(nil)

127.0.0.1:6379> EXISTS prefix:1:val prefix:1:value
(integer) 1
127.0.0.1:6379> EXISTS prefix:1:val prefix:1:name
(integer) 2

127.0.0.1:6379> EXPIRE foo 1
(integer) 0
127.0.0.1:6379> SET foo !!!
OK
127.0.0.1:6379> EXPIRE foo 1
(integer) 1

127.0.0.1:6379> GET foo
(nil)

127.0.0.1:6379> TTL prefix:1:name
(integer) -1

127.0.0.1:6379> SET foo !!!
OK
127.0.0.1:6379> EXPIRE foo 100
(integer) 1
127.0.0.1:6379> GET foo
"!!!"
127.0.0.1:6379> TTL foo
(integer) 90
127.0.0.1:6379> PERSIST foo
(integer) 1
127.0.0.1:6379> TTL foo
(integer) -1
```

<br>

## Transactions
**Redis Transactions** allow the execution of a **group** of commands in a **single** step.
Redis Transactions make two important guarantees:
- All the commands in a transaction are **serialized** and **executed sequentially**. A request sent by another client will never be served in the middle of the execution of a Redis Transaction. This guarantees that the **commands are executed as a single isolated operation**.
- The `EXEC` command triggers the execution of all the commands in the transaction.

<br>

Redis does not support rollbacks of transactions since supporting rollbacks would have a significant impact on the simplicity and performance of Redis.<br>

### Commands
Commands that are used for transactions:
- `MULTI` starts transation;
- `EXEC` triggers the execution of all the commands in the transaction;
- `DISCARD` flushes the transaction queue and will exit the transaction.;
- `WATCH`.

<br>

`EXEC` returns an array of replies, where every element is the reply of a single command in the transaction, in the same order the commands were issued.<br>

After `MULTI` command was called all commands will reply with the string `QUEUED`.<br>
A **queued command** is a command that in **transaction queue** and is scheduled for execution when `EXEC` is called.<br>

#### Example
```bash
> MULTI
OK
> INCR foo
QUEUED
> INCR bar
QUEUED
> EXEC
1) (integer) 1
2) (integer) 1
```

<br>

### WATCH explained
So what is `WATCH` really about?<br>
`WATCH` is used to provide a **check-and-set** (**CAS**) behavior to Redis transactions.<br>
If at least one watched key is modified before the EXEC command, the whole transaction aborts<br>
It is a command that will make the `EXEC` conditional: we are asking Redis to perform the transaction only if **none** of the WATCHed keys were modified.<br>
If keys were **modified** between when they were WATCHed and when the `EXEC` was received, the **entire transaction will be aborted** instead.<br>

#### Example
```bash
WATCH mykey
val = GET mykey
val = val + 1
MULTI
SET mykey $val
EXEC
```

<br>

## Lists
### Overview
**Redis lists** are *linked lists* of **string values**.

<br>

### Commands
- `LPUSH key element [element ...]` **insert** all the specified `values` at the **head** of the list stored at `key`.
- `RPUSH key element [element ...]` **insert** all the specified `values` at the **tail** of the list stored at `key`.
- `LPOP key [count]` **removes** and returns the **first** elements of the list stored at `key`.
- `RPOP key [count]` **removes** and returns the **last** elements of the list stored at `key`.
- `LLEN key` returns the length of a list at `key`.
- `LMOVE` atomically moves elements from one list to another.
- `LTRIM key start stop` reduces a list to the specified range of elements.
- `LRANGE key start stop` returns the specified elements of the list stored at `key`. 

> Notes:
> - index `-1` is the **last** element of the list.
> - index `-2` the **penultimate** element of the list.

<br>

## Sets
**Redis sets** are **unordered** *collections* of **unique strings** that act like the sets and support **set operations**.<br>

### Commands
- `SADD key member [member ...]` adds the specified values `member [member ...]` to the set stored at `key`.
- `SREM key member [member ...]` removes the specified values `member [member ...]` from the set stored at `key`.
- `SPOP key [count]` removes and returns one or more random members from the set value store at `key`.
- `SMOVE source destination member` move `member` from the set at key `source` to the set at key `destination`. 
- `SMEMBERS key` returns all the members of the set value stored at `key`.
- `SISMEMBER key member` returns
  - `1` if the element is a `member` of the set;
  - `0` if the element is not a `member` of the set, or if `key` does not exist.
- `SINTER key [key ...]` perform **intersection** of sets at keys `key [key ...]` and returns result.
- `SINTERSTORE destination key [key ...]` this command is equal to `SINTER`, but instead of returning the resulting set, it is stored in `destination`.
- `SUNION key [key ...]` perform **union** of sets at keys `key [key ...]` and returns result.
- `SUNIONSTORE destination key [key ...]` this command is equal to `SUNION`, but instead of returning the resulting set, it is stored in `destination`.
- `SDIFF key [key ...]` perform **difference** of sets at keys `key [key ...]` and returns result.
- `SDIFFSTORE destination key [key ...]` this command is equal to `SDIFF`, but instead of returning the resulting set, it is stored in `destination`.
- `SCARD key` returns the set **cardinality** (number of elements) of the set stored at `key`.

<br>

## Hashes
**Redis hashes** are record types modeled as collections of *field-value pairs*.<br>
Example: `HSET user:123 username martina firstName Martina lastName Elisa country GB`.<br>

### Commands
- `HSET key field value [field value ...]` sets the specified `fields` to their respective `values` in the hash stored at `key`. This command overwrites the values of specified fields that exist in the hash.
- `HGET key field` returns the value associated with `field` in the hash stored at `key`.
- `HMGET key field [field ...]` returns the value**s** associated with the specified `fields` in the hash stored at `key`.
- `HVALS key` returns all values in the hash stored at `key`.
- `HKEYS key` returns all field names in the hash stored at `key`.
- `HEXISTS key field` returns
  - `1` if the hash contains `field`.
  - `0` if the hash does not contain `field`, or `key` does not exist.
- `HDEL key field [field ...]` removes the specified `fields` from the hash stored at `key`.

<br>

## Sorted sets
**Redis sorted sets** are **ordered** *collections* of **unique strings** that act like the sets and support **set operations**.<br>

### Commands
Some of commands are similar to `Redis sets`, but starts with **Z**, e.g., `ZADD`.<br>
**Redis sorted sets** also introduces new commands, `ZRANGE key start stop`.<br>

<br>

## Streams

<br>

# Redis deployment methods
There are 4 variants to deploy Redis:
1. **Single instance** of Redis.
2. **Redis HA** (master/slave).
3. **Redis Sentinel** (separete service that control redis nodes: master and its slave).
4. **Redis Cluster** (sharding).

<br>

# RESP protocol
**RESP** the contraction for **RE**dis **S**erialization **P**rotocol.<br>
Redis uses **RESP** as a request-response protocol in the following way:
- clients send commands to a Redis server with one of the **RESP types**.
- the server replies with one of the **RESP types**.

In RESP, different parts of the protocol are always terminated with **CRLF**.<br>

In RESP, the **first byte** determines the **data type**.<br>

RESP data types **encoding**:
|Data type|Encoding|Example|
|:--------|:-------|:------|
|**Simple Strings**|`+` followed by a string that **cannot** contain a **CR** or **LF** character (*no newlines are allowed*), and terminated by **CRLF**|`+Some string\r\n`|
|**Errors**|`-` followed by a string that **cannot** contain a **CR** or **LF** character (*no newlines are allowed*), and terminated by **CRLF**.|`-Error message\r\n`|
|**Integers**|`:` followed by integer literal and terminated by **CRLF**.|`:1000\r\n`|
|**Bulk Strings**|`$` followed by the **number of bytes** composing the string (a prefixed length), terminated by **CRLF**, then **actual string data** terminated by **CRLF**|`$5\r\nhello\r\n`|
|**Arrays**|`*` followed by the **number of elements** in the array as a decimal number, followed by **CRLF**, then sequence of elements, every element is in RESP type notation.|**Empty array**: `*0\r\n`. Array with elements of **mixed types**: `*5\r\n:1\r\n:2\r\n:3\r\n:4\r\n$5\r\nhello\r\n`|

<br>

**Bulk Strings** are used in order to represent a single **binary-safe** string up to **512 MB** in length.<br>
