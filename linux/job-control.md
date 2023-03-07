# Fundamental concepts of job control in UNIX
In Unix **every process** belongs to a **group** which in turn belongs to a **session**:
*Session* (**SID**) **->** *Process Group* (**PGID**) **->** *Process* (**PID**)

<br>

## Process groups
**Each** *process* in the system is a member of a **process group**.<br>
Process groups are identified by the **process group ID** (**PGID**).<br>
When a process is created with `fork()`, the child inherits the **PGID** of its parent.<br>
One key goal of process groups is that all members of a group can be signalled at once.<br>

<br>

## Group leader
**Each** *process group* has a **group leader**.<br>
The **group leader** is the process whose **PID** is the same as the **PGID**.<br>

<br>

## Sessions
**Each** *process group* is a member of a **session**.<br>
**Sessions** are identified by a **session ID** (**SID**).<br>

<br>

## Session leader
**Each** *session* has a **session leader**.<br>
The **session leader** is the process whose **PID** is the same as its **PGID** and its **SID**.<br>

<br>

## Controlling terminal
An important attribute of a process is its **controlling terminal**.
**Controlling terminals** are, in fact, associated with sessions: **each** *session* can have **at most one** *controlling terminal*, and a *controlling terminal* can be associated with **at most one** *session*.
When you create a process with `fork()`, the child process inherits the **controlling terminal** from its parent.
Thus, **all** the processes in a session **inherit** the **controlling terminal** from the **session leader**.

<br>

## setsid()
A **process** can **detach** from its **controlling terminal** by creating a new session with the `setsid()` function.

<br>

# Daemonization
Daemons **should not** have *controlling terminals*. If a **daemon** has a **controlling terminal**, it **can receive signals** (e.g., **SIGTTIN**, **SIGTTOU**, **SIGTSTP**, **SIGHUP**, **SIGINT**, **SIGQUIT**) that might cause it to **halt** or **exit unexpectedly**.<br>

To be absolutely sure that daemon cannot **acquire a controlling terminal**, the **double-fork technique** must be used.

<br>

> **Note**: <br>
> 1) The `setsid()` will **fail** if the calling process is the **group leader**.<br>
> 2) **Only** a **session leader** can open a **controlling terminal**.<br>

<br>

## Double-fork technique
- The **first** `fork()` is done in order to **stop** being the *group leader*, because **child** inherits **PGID** and `child's PID` != `PGID`;
- Then, **child** must call `close()` for all opened `fd`;
- Then, **child** must call `setsid()` to became *session leader* and to detache from *controlling terminal* that was **inherited** after `fork()`, but **child** **still** can open *controlling terminal*.
- The **second** `fork()` is done in order to **stop** being the *session leader*, because **child** inherits **SID** and `child's PID` != `SID`, so, the second `fork()` .

<br>

> **Note** <br>
> The **double-fork technique** ensures that the **daemon process** is **detached** from **controlling terminal** and **isn't** the **session leader**, which in turn **guarantees** that daemon **will not be able** to **acquire a controlling terminal**.<br>

<br>

# Job control
**Job control** is a feature supported by the UNIX-like operating systems.<br>
From OS's point of view **job** is a **set of processes** that are **all** in the same **process group**.<br>

A shell that supports **job control** has its own representation of **job**, e.g., in `sh`, `bash`, `zsh` **job** is **any** **single command** or whole **pipeline** (*pipeline* is sequence of commands separated by the operator `|`). The basic idea is that **whole pipeline** is a **job**, because **every** process in a pipeline should be **manipulated** (stopped, resumed, killed) **simultaneously**. That's why `kill` allows you to send signals to entire process groups.<br>

There 3 kinds of **job** in shell:
- **foreground job** is an executing job that **has** *access* to the **controlling terminal**;
- **background job** is an executing job that **hasn't any** *access* to the **controlling terminal**;
- **suspended job** is job that **isn't** executing.

<br>

> **Note** <br>
> **Foreground job** **receives** **keyboard-generated signals** , e.g., `SIGINT`.<br>
> **Background jobs** are **immune** to **keyboard-generated signals**.<br>

<br>

A shell that supports **job control** must **arrange to control** which **job** can use the terminal at any time.<br>
Otherwise there might be multiple jobs trying to read from the terminal at once, and confusion about which process should receive the input typed by the user.<br>
To prevent this, the **shell must cooperate** with the **terminal driver** and must provide tools to **suspende**, **resume**, **terminate** its **jobs**.<br>
There is **termios API** to do this.<br>

When a session ends when the user logs out (exits the shell, which terminates the session leader process), 
the shell process sends `SIGHUP` to all jobs, and waits for the process groups to end before terminating itself.<br>
Alternatives to prevent jobs from being terminated is to use `nohup` or a **terminal multiplexer**.<br>

<br>

## Job control signals
|Signal|Description|
|:-----|:----------|
|`SIGINT`|Sent to a **foreground job** to **interrupt** it. It is typically send when a user typing the `Ctrl-C`. By default, `SIGINT` terminates the process.|
|`SIGTSTP`|Sent to a **foreground job** to **stop** it. It is typically send when a user typing the`Ctrl-Z`.|
|`SIGTTIN`|Sent to a **background job** to **stop** it when it attempts to **read** from the *controlling terminal*.|
|`SIGTTOU`|Sent to a **background job** to **stop** it when a user attempts to **write** to or **modify** the *controlling terminal*.|
|`SIGCONT`|Sent to a **stopped job** to **continue** it.|
|`SIGSTOP`|Sent to a process to **stop** it. This signal **cannot be caught or ignored**.|
|`SIGHUP`|Sent to **all jobs** when **session leader** (*shell* is *session leader* for all its descendants) exits.|

<br>

> **SIG**: common prefix, means *signal*
> **TT**: means *TTY*
> **OU**: means *output*
> **IN**: means *input*

<br>

### `SIGCONT`
A **suspended job** can be **resumed** as a **background job** with the `bg %n`, or as the **foreground job** with `fg %n`.
In either case, the shell redirects I/O appropriately, and sends the `SIGCONT` signal to the process, which causes the operating system to resume its execution.
In Bash, a program can be started as a **background job** by appending `&` to the command line; its `output` is directed to the **terminal** (potentially interleaved with other programs' output), but it **cannot** read from the terminal `input`.

<br>

### `SIGTTIN`
The `SIGTTIN` signal is sent to a process in **background job** when it attempts to **read** in from the *controlling terminal*.<br>

<br>

#### Example
```bash
$ python3 -c 'input()' &
[1] 62614
[1]  + suspended (tty input)  python3 -c 'input()'
```

<br>

### `SIGTTOU`
The `SIGTTOU` signal is sent to a process in **background job** when it attempts to **write** to the *controlling terminal* and if the `TOSTOP` **mode** is set.<br>
The `SIGTTOU` signal is sent to a process in **background job** when it attempts to **change** its *controlling terminal* settings **regardless** of whether `TOSTOP` is set or not.<br>

<br>

> **Note** <br>
> By default `TOSTOP` **mode** is **not** set.<br>
> To set `TOSTOP` **mode** run `stty tostop`.<br>
> To unset `TOSTOP` **mode** run `stty -tostop`.<br>

<br>

#### Examples: change the *controlling terminal* settings
```bash
$ python3 -c 'import tty, sys; tty.setcbreak(sys.stdin)' &
[3] 66017
[3]  + suspended (tty output)  python3 -c 'import tty, sys; tty.setcbreak(sys.stdin)'
```

<br>

#### Examples: write to the *controlling terminal* when `TOSTOP` **mode** is not set
```bash
$ python3 -c 'print("Hello world!")' &
[3] 65819
[3] done python3 -c 'print("Hello world!")'
```

<br>

#### Examples: set `TOSTOP` mode and then write to the *controlling terminal*
```bash
$ stty
speed 38400 baud;
lflags: echoe echok echoke echoctl tostop pendin
iflags: iutf8
oflags: -oxtabs
cflags: cs8 -parenb

$ stty -tostop

$ stty
speed 38400 baud;
lflags: echoe echok echoke echoctl pendin
iflags: iutf8
oflags: -oxtabs
cflags: cs8 -parenb

$ stty tostop

$ stty
speed 38400 baud;
lflags: echoe echok echoke echoctl tostop pendin
iflags: iutf8
oflags: -oxtabs
cflags: cs8 -parenb

$ python3 -c 'print("Hello world!")' &
[5] 75052
[5]  + suspended (tty output)  python3 -c 'print("Hello world!")'
```

<br>


## Termios API
There 2 functions to implement job control in shell: `tcgetpgrp(3)` and `tcsetpgrp(3)`.

`tcgetpgrp(3)` **get** terminal foreground process group.
`tcsetpgrp(3)` **set** terminal foreground process group.

The function `tcgetpgrp(fd)` returns the **PGID** of the **foreground job** on the terminal associated to `fd`, which must be the *controlling terminal* of the calling process.
The function `tcsetpgrp(fd, pgrp)` makes the **job** with **PGID** `pgrp` the **foreground job** on the terminal associated to `fd`, which must be the *controlling terminal* of the calling process.


```C
/* Run the foreground job.  */
tcsetpgrp (shell_terminal, j->pgid);

/* Put the shell back in the foreground; it's equal to run the background job.  */
tcsetpgrp (shell_terminal, shell_pgid);
```

<br>

## Job control commands
**Job control commands** enable you to place jobs in the **foreground** or **background**, and to **start** or **stop** jobs.<br>
**Current job** is the one **most recently** *started* in the **background**, or *suspended* from the **foreground**.<br>

|Bash function|Description|
|:------------|:----------|
|`jobs`|Lists all jobs|
|`jobs -l`|Lists all jobs with PGID|
|`bg %n`|Put a **job** in the **background**, where `n` is the job number.|
|`fg %n`|Put a **job** in the **foreground**, where `n` is the job number.|
|`stop %n`|Suspend a **background** job.|
|`command &`|Runs a `command` in the **background**.|
|`nohup command`|Runs a `command` and detaches it from *controlling terminal*.|

When shell starts a **job** *asynchronously*, it prints a line that looks like `[1] 25647` indicating that this **job** has **number** `1` and that the PID of the **last proces**s in the **pipeline** associated with this **job** is `25647`.<br>
When a **background job** is **complete** and you press **Return**, the shell displays a message indicating the **job** is **done**.<br>
