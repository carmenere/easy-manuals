## Description
Util **``lsof``** outputs information about all opened file descriptors and processes using them.

<br>

## Options
|Option|Description|Example|
|:-----|:----------|:------|
**-u** ``<USERNAME>``|Displays all file descriptors that opened by the **user** with name equal to ``<USERNAME>``.|lsof **–u** *``an.romanov``*
**-p** ``<PID>``|Displays all file descriptors that opened by the **process** with **PID** equal to ``<PID>``.|lsof **–p** *``22``*
**-g** ``<PGID>``|Displays all file descriptors that opened by the **process group** whose **PGID** is ``<PGID>``.|lsof **–g** *``100``*
**+d** ``<DIR>``|Displays all opened files that located in **specific directory** ``<DIR>``, **not** recursively.|lsof **+d** *``~``*
**+D** ``<DIR>``|Displays all opened files that located in **specific directory** ``<DIR>``, **recursively**.|lsof **+D** *``~``*
``<PATH>``|Displays all processes that opened **specific file** whose path is ``<PATH>``.|lsof *``/dev/null``*
**-U**|Displays all opened **UNIX** sockets.|lsof **–U**
**-i** ``<PATTERN>``|Displays all opened **INET** sockets and appropriate processes. Parameter ``<PATTERN>`` has following format: \[**4**\|**6**\]\[**Protocol**\]\[**@**(**Hostname**\|**Hostaddr**)\]\[**:**(**service**\|**port**)\].|lsof **–i** *``4UDP``*
**-s** ``<FILTER>``|Filters sockets. Parameter ``<FILTER>`` has following format \[**Protocol**:**State**\]. Some common **TCP** state names are: *<ul><li>CLOSED</li><li>IDLE</li><li>BOUND</li><li>LISTEN</li><li>ESTABLISHED</li><li>SYN_SENT</li><li>SYN_RCDV</li><li>ESTABLISHED</li><li>FIN_WAIT1</li><li>CLOSE_WAIT</li><li>CLOSING</li><li>FIN_WAIT_2</li><li>LAST_ACK</li><li>TIME_WAIT</li></ul>*|lsof -i 4TCP **-s** *``TCP:LISTEN``*
**-n**|Disable resolving **IP addresses** to doman names.|lsof **–n**
**-P**|Disable resolving **TCP/UDP ports** to service names.|lsof **–P**
