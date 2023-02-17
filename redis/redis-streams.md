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

Drawbacks:
- When a message is published, if the consumer doesn’t receive it right now, the message disappears.
- All messages are gone away if Redis is shutdown.

<br>

## Lists
The **publisher** run ```RPUSH <key> <message>``` command.<br>
The **consumers** runs ```LPOP <key> <count>``` or ```BLPOP <key> <timeout>```. ```BLPOP``` is used to wait for a message in blocking mode.<br>
If consumer read message with ```BLPOP``` it means others consumers will not see this message.

<br>

# Redis Streams
