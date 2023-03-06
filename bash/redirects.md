# **STDIN**, **STDOUT**, **STDERR**
There are 3 well-known fd:
- `/dev/stdin`: **standard input** (**STDIN**) has `fd`=**0**;
- `/dev/stdout`: **standard output** (**STDOUT**) has `fd`=**1**;
- `/dev/stderr`: **standard error** (**STDERR**) has `fd`=**2**

<br>

# Inheritance of **STDIN**, **STDOUT**, **STDERR**
After the Linux kernel initialization is completed, the kernel prepares to execute the user-space `init` process.<br>
The file is being executed resides in `/sbin/init`, `/etc/init`, or `/bin/init`.<br>
If none of those are found, `/bin/sh` is run as a recovery measure in case the real `init` got lost or corrupted.<br>
As an alternative, the user can specify on the kernel command line which file the `init` thread should execute.<br>

In the case of `systemd`, `init` is actually a **symbolic link** to file `/usr/lib/systemd/systemd`. The systemd reads files (**units**) from the directories.<br>

Order:
- `systemd` has **service unit** `getty@tty1.service` that invokes `agetty`; (in *Sys V Init* `init` invokes `getty` directly.);
- `agetty` opens a **virtual terminal** (`/dev/ttyN`), **prompts** for a *login name* and invokes the `/bin/login` command and inherits all its file descriptors;
- `/bin/login` invokes **shell** and reads config `/etc/login.defs` for preparing **environmant variables**, e.g., config parameter `ENV_PATH` is used to configure `PATH` variable; 
- in turn, the **shell process** (`sh`, `bash`, `zsh`, ... ) inherits all file descriptors from `login` process, including **STDIN**, **STDOUT**, **STDERR**;
- all processes spawned by the shell also inherit all of its file descriptors, including **STDIN**, **STDOUT**, **STDERR**.

<br>

# Redirects
Before a command is executed, its **input** and **output** may be **redirected** using a special notation interpreted by the shell.<br>
**Redirection operators** are
|Operator|Example|Description|Default behaviour|
|:-------|:------|:----------|:----------------|
|`<`|`command fd<path_to_file`|**Input redirection** operator. **Reads** from a file `path_to_file` to `fd`.|If `fd` is **not** specified, the `0` is used.|
|`>`|`command fd>path_to_file`|**Output redirection** operator. **Writes** `fd` to a file `path_to_file`|If `fd` is **not** specified, the `1` is used.|
|`>>`|`command fd>>path_to_file`|**Append** `fd` to a file `path_to_file`.|If `fd` is **not** specified, the `1` is used.|
|`<<`|`command fd<<EOF`|**Here documents** operator.|If `fd` is **not** specified, the `0` is used.|
|`<<<`|`command fd<<expression`|**Here strings** operator.|If `fd` is **not** specified, the `0` is used.|
|`<( CMD )`|`command <( CMD )`|**Process substitution** operator. It evaluates the `CMD` inside and redirects its output to a **FIFO**, a named pipe that gets a virtual file descriptor inside `/dev/fd` assigned. It acts like a **temporary file** that contains the output of the evaluated command `CDM`.||

<br>

> **Here documents** operator instructs the shell to read **input** from the current source until a line containing only `EOF` (with no trailing blanks) is seen.

<br>

> Note that the **order of redirections** is **significant**.<br>
>
> This command
> ```bash
> command > somefile 2>&1
> ```
> redirects both **STDOUT** and **STDERR** to the file `somefile`.
>
> This command
> ```bash
> command 2>&1 > somefile 
> ```
> redirects **STDOUT** to the file `somefile` and **STDERR** to file to which **STDOUT** was connected before if was redirected to `somefile`.


<br>

## Redirect STDOUT and STDERR to the same file
```bash
command >path_to_file 2>&1
```

Also there is **alternative syntax**, but some shells **don't support this**, e.g., `sh`:
```bash
command &>path_to_file
```

<br>

### Suppress only STDERR
```bash
command 2>/dev/null
```

### Suppress STDOUT and STDERR
```bash
command >/dev/null 2>&1
```

<br>

## Duplicating file descriptors
### Input
```bash
command fd<&origin_fd
```
If `fd` is **not** specified, the **STDIN** (`fd` **0**) is used.

<br>

### Output
```bash
command origin_fd>&fd
```
If `fd` is **not** specified, the **STDOUT** (`fd` **1**) is used.

<br>

## Syscalls
There is syscall `int dup2(int oldfd, int newfd)` to duplicate fd.<br>
After a successful return, the `old` and `new` file descriptors are refer to the same file and may be used interchangeably.<br>

<br>

#### Example: output redirection
The command `command > /var/log/test` causes to following sequence of syscalls:
1. `fd = open('/var/log/test', O_CREAT|O_TRUNC|O_WRONLY, 0644)`
2. `dup2(fd, 1)`

<br>

#### Example: duplicating descriptors
The command `command 2>&1` causes to following sequence of syscalls:
1. `dup2(1, 2)`

<br>

#### Example: command m>file n>&m
The command `command 2>&1` causes to following sequence of syscalls:
1.	`newfd = open(file, O_CREAT|O_TRUNC|O_WRONLY, mode)`
2.	`dup2(newfd, m)`
3.	`dup2(m, n)`

<br>

#### Example: command n>&m m>file, 
1.	`dup2(m, n)`
2.	`newfd = open(file, O_CREAT|O_TRUNC|O_WRONLY, mode)`
3.	`dup2(newfd, m)`
