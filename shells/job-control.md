# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [Fundamental concepts of job control in UNIX](#fundamental-concepts-of-job-control-in-unix)
  * [Process groups](#process-groups)
  * [Group leader](#group-leader)
  * [Sessions](#sessions)
  * [Session leader](#session-leader)
  * [Controlling terminal](#controlling-terminal)
  * [Syscall `setsid()`](#syscall-setsid)
* [Daemonization](#daemonization)
  * [Double-fork technique](#double-fork-technique)
* [Job control](#job-control)
  * [Foreground and background jobs](#foreground-and-background-jobs)
  * [Example: async DNS resolver](#example-async-dns-resolver)
  * [Job control signals](#job-control-signals)
    * [`SIGHUP`](#sighup)
    * [`SIGCONT`](#sigcont)
    * [`SIGTTIN`](#sigttin)
      * [Example](#example)
    * [`SIGTTOU`](#sigttou)
      * [Examples: change the *controlling terminal* settings](#examples-change-the-controlling-terminal-settings)
      * [Examples: write to the *controlling terminal* when `TOSTOP` **mode** is not set](#examples-write-to-the-controlling-terminal-when-tostop-mode-is-not-set)
      * [Examples: set `TOSTOP` mode and then write to the *controlling terminal*](#examples-set-tostop-mode-and-then-write-to-the-controlling-terminal)
  * [Termios API](#termios-api)
  * [Job control commands](#job-control-commands)
<!-- TOC -->

<br>

# Fundamental concepts of job control in UNIX
In Unix **every process** belongs to a **group** which in turn belongs to a **session**:
*Session* (**SID**) **->** *Process Group* (**PGID**) **->** *Process* (**PID**)

<br>

## Process groups
**Each** *process* in the system is a member of a **process group**.<br>
Process groups are identified by the **process group ID** (**PGID**).<br>
When a process is created with `fork()`, the child process **inherits** the **PGID** of its parent.<br>

<br>

## Group leader
**Each** *process group* has a **group leader**.<br>
The **group leader** is the process whose **PID** is the same as its **PGID**.<br>

<br>

## Sessions
**Each** *process* in the system is a member of a **session**.<br>
**Sessions** are identified by a **session ID** (**SID**).<br>

<br>

## Session leader
**Each** *session* has a **session leader**.<br>
The **session leader** is the process whose **PID** is the same as its **PGID** and its **SID**.<br>

<br>

## Controlling terminal
**Each** *session* can have **at most one** *controlling terminal*, and a *controlling terminal* can be associated with **at most one** *session*.<br>
When you create a process with `fork()`, the child process **inherits** the **controlling terminal** from its parent.<br>
Thus, **all** the processes in a session **inherit** the **controlling terminal** from the **session leader**.<br>

<br>

> **Note**: <br>
> **Only** a **session leader** can open a **controlling terminal**.<br>

<br>

## Syscall `setsid()`
Syscall `setsid()`:
- **detaches** *calling process* from its **controlling terminal**;
- **creates new session**;
- **makes** *calling process* the **session leader**.

<br>

> **Note**
> `setsid()` will **fail** if the *calling process* is the **group leader**.<br>

<br>

# Daemonization
Daemons **should not** have *controlling terminals*.<br>
If a **daemon** has a **controlling terminal**, it **can receive signals** (e.g., **SIGTTIN**, **SIGTTOU**, **SIGTSTP**, **SIGHUP**, **SIGINT**, **SIGQUIT**) that might cause it to **halt** or **exit unexpectedly**.<br>

To be absolutely sure that daemon cannot **acquire a controlling terminal**, the **double-fork technique** must be used.

<br>

## Double-fork technique
- The **first** `fork()` is done in order to **stop** being the *group leader*, because **child** inherits **PGID** and `child's PID != PGID`;
- Then, **child** *may* call `close()` for all opened `fd`;
- Then, **child** *must* call `setsid()` to became *session leader* and to detache from *controlling terminal* that was **inherited** after `fork()`, but **child still** can open *controlling terminal*.
- The **second** `fork()` is done in order to **stop** being the *session leader*, because **child** inherits **SID** and `child's PID != SID`.

<br>

> **Note**: <br>
> The **double-fork technique** ensures that the **daemon process** is **detached** from **controlling terminal** and it **isn't** the **session leader**, which in turn **guarantees** that daemon **will not be able** to **acquire a controlling terminal**.<br>

<br>

# Job control
**Job control** is a feature supported by the UNIX-like operating systems.<br>
From OS's point of view **job** is a **set of processes** that are **all** in the same **process group**.<br>

A shell that supports **job control** has its own representation of **job**.<br>
**Job** is *any* **single command** or **whole pipeline** in `sh`, `bash`, `zsh` and others (*pipeline* is a sequence of commands separated by the `|` operator).<br>
The basic idea is that **whole pipeline** is a **job**, because **every** process in a pipeline should be **manipulated** (stopped, resumed, killed) **simultaneously**. That's why `kill` allows you to send signals to **entire process groups**.<br>

<br>

A shell that supports **job control** must **arrange to control** which **job** can use the terminal at any time.<br>
Otherwise there might be multiple jobs trying to **read** from the terminal **at once**, and confusion about which process should receive the *input* typed by the user.<br>
To prevent this, the **shell must cooperate** with the **terminal driver** and must provide tools to **suspend**, **resume**, **terminate** its **jobs**.<br>

<br>

## Foreground and background jobs
So, there are 3 kinds of **job**:
- **foreground job** is an *executing* **job** that can **read** and **write** to its **controlling terminal**;
- **background job** is an *executing* **job** that **can't read** to its **controlling terminal**, but it still able to **write** to its **controlling terminal**, but it depends on terminal settings and writing to  **controlling terminal** can be forbidden too;
- **suspended job** is **job** that **isn't** *executing*, e.g., **job** that is **stopped**.

<br>

To run command as **background job** append `&` to the end of command.<br>

<br>

> **Note**: <br>
> 1. *Foreground job* **receives keyboard-generated signals** , e.g., `Ctrl+C` -> `SIGINT`.<br>
> 2. *Background jobs* are **immune** to **keyboard-generated signals**.<br>
> 3. **Output** of *background jobs* may **interleave** with other jobs.<br>
> 4. All *background jobs* are run **asynchronously**.<br>

<br>

## Example: async DNS resolver
```bash
declare -a domains=(
    "google.com"
    "youtube.com"
    "facebook.com"
)

RESOLVED_DOMAINS=/tmp/resloved.txt

rm "${RESOLVED_DOMAINS}"
for i in "${domains[@]}"
do
   dig +noall +answer "$i" 1 >> "${RESOLVED_DOMAINS}" 2>&1 &
done

cat "${RESOLVED_DOMAINS}"

grep -E '\d+\.\d+\.\d+\.\d+' "${RESOLVED_DOMAINS}" | cut -d 'A' -f 2 | tr -d '\t' | sort | uniq | wc -l
```

<br>

## Job control signals
|Signal|Description|
|:-----|:----------|
|`SIGINT`|Sent to a **foreground job** to **interrupt** it. It is typically send when a user typing the `Ctrl-C`. By default, `SIGINT` **terminates** the process.|
|`SIGTSTP`|Sent to a **foreground job** to **stop** it. It is typically send when a user typing the`Ctrl-Z`.|
|`SIGTTIN`|Sent to a **background job** to **stop** it when it attempts to **read** from the *controlling terminal*.|
|`SIGTTOU`|Sent to a **background job** to **stop** it when a user attempts to **write** to or **modify** the *controlling terminal*.|
|`SIGCONT`|Sent to a **stopped job** to **continue** it.|
|`SIGSTOP`|Sent to a process to **stop** it. This signal **cannot be caught or ignored**.|
|`SIGHUP`|Sent to **all jobs** when **session leader** (*shell* is *session leader* for all its descendants) exits.|

<br>

> **Note**: <br>
> **SIG**: common prefix, means *signal*<br>
> **TT**: means *TTY*<br>
> **OU**: means *output*<br>
> **IN**: means *input*<br>

<br>

### `SIGHUP`
**Foreground** and **background jobs** are killed by `SIGHUP` sent by **controlling terminal** or by **shell**.<br>

When does **controlling terminal**  send `SIGHUP`?<br>
**Controlling terminal** sends `SIGHUP` to **session leader** (usually to **shell**):
- when terminal becomes **disconnected**. 

<br>

When does **bash** send `SIGHUP`?<br>
**Bash** sends `SIGHUP` to **all jobs** (*foreground* and *background*):
- when it **receives** `SIGHUP`, and it is an **interactive** shell;
- when it **exits**, it is an **interactive** and **login** shell, and `huponexit` option is **set**.

<br>

### `SIGCONT`
A **suspended job** can be **resumed** as a **background job** with the `bg %n`, or as the **foreground job** with `fg %n`.<br>
In either case, the shell redirects I/O appropriately, and sends the `SIGCONT` signal to the process, which causes the operating system to resume its execution.<br>

<br>

### `SIGTTIN`
The `SIGTTIN` signal is sent to a **background job** when it attempts to **read** in from the *controlling terminal*.<br>

<br>

#### Example
```bash
$ python3 -c 'input()' &
[1] 62614
[1]  + suspended (tty input)  python3 -c 'input()'
```

<br>

### `SIGTTOU`
The `SIGTTOU` signal is sent to a **background job** when it attempts to **write** to the *controlling terminal* and if the `TOSTOP` **mode** is set.<br>
The `SIGTTOU` signal is sent to a **background job** when it attempts to **change** its *controlling terminal* settings **regardless** of whether `TOSTOP` is set or not.<br>

<br>

> **Note** <br>
> By default `TOSTOP` **mode** is **not** set.<br>
> To **set** `TOSTOP` **mode** run `stty tostop`.<br>
> To **unset** `TOSTOP` **mode** run `stty -tostop`.<br>

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
There 2 functions to implement **job control** in shell: `tcgetpgrp(3)` and `tcsetpgrp(3)`:
- `tcgetpgrp(3)` **get** terminal foreground process group;
- `tcsetpgrp(3)` **set** terminal foreground process group.

<br>

The function `tcgetpgrp(fd)` returns the **PGID** of the **foreground job** on the terminal associated to `fd`, which must be the *controlling terminal* of the *calling process*.<br>
The function `tcsetpgrp(fd, pgrp)` makes the **job** with **PGID** `pgrp` the **foreground job** on the terminal associated to `fd`, which must be the *controlling terminal* of the *calling process*.

<br>

```C
/* Run the foreground job.  */
tcsetpgrp (shell_terminal, j->pgid);

/* Put the shell back in the foreground.  */
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
|`command &`|`&` runs a `command` in the **background**.|
|`nohup command`|`nohup` runs a `command` and **detaches** it from *controlling terminal*, but the **job** is **still in** *shell's job control*|
|`disown command`|`disown` **removes** the **job** from the *shell's job control*, but **job** is **still connected** to the terminal.|

<br>

> Note: <br>
> If `%n` is **not** supplied **current job** number is used.

<br>

When shell starts a **job** *asynchronously*, it prints a line that looks like `[1] 25647` where
- `1` is the **job number**;
- `25647` is the **PID** of the **last process** in the **pipeline**.<br>

<br>

When a **background job** is **completed** and you press **Return**, the shell displays a message indicating the **job** is **done**.<br>
