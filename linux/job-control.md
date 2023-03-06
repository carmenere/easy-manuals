# Fundamental concepts of job control in UNIX:

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

# Daemons and Double-fork technique
Daemons **should not** have controlling terminals.<br>
If a **daemon** has a **controlling terminal**, it **can receive signals** that might cause it to **halt** or **exit unexpectedly**, e.g., **SIGTTIN**, **SIGTTOU**, **SIGTSTP**, **SIGHUP**, **SIGINT**, **SIGQUIT**.<br>

If you want to be absolutely sure that your daemon cannot be tricked into **acquiring a controlling terminal**, the **double-fork technique** will give you such **guarantees**.

<br>

> Note:<br>
> The `setsid()` will **fail** if the calling process is a **group leader**.<br>
> **Only** a **session leader** can open a **controlling terminal**.

<br>

So, 
- the **first** `fork()` is done in order to **stop** being the *group leader*, because **child** inherits **PGID** and `child's PID` != `PGID`;
- call `close()` for all opened `fd`;
- call `setsid()` to became *session leader* and detache from *controlling terminal* **inherited** after `fork()`, but process **still** can open *controlling terminal*.
- the **second** `fork()` is done in order to **stop** being the *session leader*, because **child** inherits **SID** and `child's PID` != `SID`, so, the second `fork()` **guarantees** that daemon will not be able to open a new *controlling terminal*.
