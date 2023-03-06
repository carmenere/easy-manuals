# **STDIN**, **STDOUT**, **STDERR**
There are 3 well-known fd:
- **standard input** (**STDIN**) has `fd`=**0**;
- **standard output** (**STDOUT**) has `fd`=**1**;
- **standard error** (**STDERR**) has `fd`=**2**

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
|`<`|`command fd<path_to_file`|**Read** from a file `path_to_file` to `fd`.|If `fd` is **not** specified, the **STDIN** is used.|
|`>`|`command fd>path_to_file`|**Write** `fd` to a file `path_to_file`|If `fd` is **not** specified, the **STDOUT** is used.|
|`<<`|`command fd<<EOF`|**Here documents** operator. This type of redirection instructs the shell to read **input** from the current source until a line containing only `EOF` (with no trailing blanks) is seen.|If `fd` is **not** specified, the **STDIN** is used.|
|`>>`|`command fd>>path_to_file`|**Append** `fd` to a file `path_to_file`.|If `fd` is **not** specified, the **STDOUT** is used.|
|`<<<`|`command fd<<expression`|**Here strings** operator.|If `fd` is **not** specified, the **STDIN** is used.|

<br>

> Note that the **order of redirections** is **significant**.<br>
>
> ```bash
> command > somefile 2>&1
> ```
> redirects both **STDOUT** and **STDERR** to the file `somefile`.
> 
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

### Suppress only STDERR
```bash
command 2>&1
```

### Suppress STDOUT and STDERR
```bash
command >/dev/null 2>&1
```

<br>

## Duplicating file descriptors
### 
```bash
command fd<&origin_fd
```
If `fd` is **not** specified, the **STDIN** (`fd` **0**) is used.

```bash
command origin_fd>&fd
```
If `fd` is **not** specified, the **STDOUT** (`fd` **1**) is used.




Порядок важен! Перенаправление дескрипторов осуществляется в том порядке, в котором они указываются.

command m>file n>&m
Перенаправляет дескриптор m в файл file, а затем дескриптор n перенаправляется в дескриптор m. 

1.	fork()/clone()
2.	newfd = open(file, O_CREAT|O_TRUNC|O_WRONLY, mode)
3.	dup2(newfd, m)
4.	dup2(m, n)

command n>&m m>file, 
то последовательность действий будет следующей:
1.	fork()/clone()
2.	dup2(m, n)
3.	newfd = open(file, O_CREAT|O_TRUNC|O_WRONLY, mode)
4.	dup2(newfd, m)

В этом случае дескриптор n будет перенаправлен в файл, который был ассоциирован с дескриптором m до того, как он был перенаправлен в file.



command >file 2>&1

подавляем весь вывод
command >/dev/null 2>&1



Bash handles several filenames specially when they are used in redirections, as described in the following table. If the operating system on which Bash is running provides these special files, bash will use them; otherwise it will emulate them internally with the behavior described below.

/dev/fd/fd
If fd is a valid integer, file descriptor fd is duplicated.

/dev/stdin
File descriptor 0 is duplicated.

/dev/stdout
File descriptor 1 is duplicated.

/dev/stderr
File descriptor 2 is duplicated.



Moving File Descriptors