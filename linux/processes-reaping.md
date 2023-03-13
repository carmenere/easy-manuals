# Process tree
All processes are ordered in a **tree** in UNIX-like OS.<br>
Each process can spawn child processes, and each process has a parent except for the **top-most** process.<br>
This **top-most** process is the `init` process. It is **started by the kernel** when you boot your system.<br>

<br>

# Zombie
An **orphan process** is a process that is still executing, but whose **parent** has **died**.<br>
A **zombie process** or **defunct process** is a such process that has terminated but **wasnt't reaped** by parent.<br>

After process had been terminated the kernel deallocate all its memory and process becomes **zombie process**, which still has an entry in the **kernel process table**, and if this table fills, kernel will not be possible to create further processes.<br>
The kernel maintains a minimal set of information about the **zombie process** (**PID**, **termination status**, **resource usage information**) in order to allow the parent to later perform a `wait()` or `waitpid()` to obtain information about the child.<br>

<br>

# Reaping
The process of **eliminating** *zombie processes* is known as **reaping**.<br>

There are some syscalls to **reap** *zombie*:
- `wait()`: *blocking*.
- `waitpid()`: *non-blocking*.

<br>

Application can call `wait()` or `waitpid()` periodically or it can register `SIGCHLD` **handler**.<br>
Many applications **reap** their *child* processes correctly.<br>

<br>

# Init
If a *parent* **fails**, the **zombie** will be left in the **process table**, causing a **resource leak**.<br>
When a process loses its parent, `init` becomes its new parent, e.g., `init` adopts **zombies**.<br>
`init` periodically executes the `wait()` or `waitpid()` system call to **reap** any **zombies**.<br>

<br>

## Relationship with Docker
So how does this relate to Docker?
It is common to run only one service inside container, but it is most likely, this process is not written to behave like a proper `init` process.
