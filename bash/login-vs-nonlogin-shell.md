# Table of contents
- [Table of contents](#table-of-contents)
- [List and change shell](#list-and-change-shell)
- [Modes of shell](#modes-of-shell)
  - [Interactive, non-login shell](#interactive-non-login-shell)
  - [Interactive login shell](#interactive-login-shell)
  - [Non-interactive, non-login shell](#non-interactive-non-login-shell)
  - [Non-interactive login shell](#non-interactive-login-shell)
- [Startup files](#startup-files)
  - [sh](#sh)
  - [bash](#bash)
  - [`zsh`](#zsh)
- [Prepare files for examples](#prepare-files-for-examples)
    - [`~/test.sh`](#testsh)
    - [`~/.shrc`](#shrc)
    - [`~/.bashrc`](#bashrc)
    - [`~/.zshrc`](#zshrc)
    - [`~/.profile`](#profile)
    - [`~/.zprofile`](#zprofile)
- [Order of reading startup files](#order-of-reading-startup-files)
  - [sh](#sh-1)
    - [Non-Login and Interactive mode](#non-login-and-interactive-mode)
    - [Login and Interactive mode](#login-and-interactive-mode)
    - [Login and Non-interactive mode](#login-and-non-interactive-mode)
    - [Non-login and Non-interactive mode](#non-login-and-non-interactive-mode)
  - [bash](#bash-1)
    - [Non-Login and Interactive mode](#non-login-and-interactive-mode-1)
    - [Login and Interactive mode](#login-and-interactive-mode-1)
    - [Login and Non-interactive mode](#login-and-non-interactive-mode-1)
    - [Non-login and Non-interactive mode](#non-login-and-non-interactive-mode-1)
  - [zsh](#zsh-1)
    - [Non-Login and Interactive mode](#non-login-and-interactive-mode-2)
    - [Login and Interactive mode](#login-and-interactive-mode-2)
    - [Login and Non-interactive mode](#login-and-non-interactive-mode-2)
    - [Non-login and Non-interactive mode](#non-login-and-non-interactive-mode-2)

<br>

# List and change shell
**List** all avaliable shells:
- `cat /etc/shells`

<br>

**Change default** shell:
- `chsh -s /bin/bash`
- `chsh -s /bin/zsh`

<br>

# Modes of shell
There are 4 **modes** of shell:
- if the `-i` option is present, the shell is **interactive**;
- if the `-i` option is **not** present, the shell is **non-interactive** (**source** or **execute** **script**);
- if the `-l` option is present, the shell is **login**;
- if the `-l` option is **not** present, the shell is **non-login**;

<br>

When you **log in** your machine from the **command line**, via **ssh**, or run a command such as **su - username**, you get shell in **interactive** and **login** mode.<br>
When you open a **terminal emulator** (**gnome-terminal** for example), you get shell in **interactive** and **non-login** mode.<br>
When you run a shell **script**, you always get shell in a **non-interactive** and **non-login** mode. But **scripts** may be **forced** to run in **interactive** and **login** mode with the `-i` and `-l` options.<br>

<br>

|Mode|Description|
|:---|:----------|
|**Interactive** + **Login** *shell*|Run shell **with** `-l` option and **with** `-i` option. Examples:<br>- **log** into a **remote** computer via `ssh`;<br>- **log** into a **local** computer via `tty`;|
|**Interactive** + **Non-login** *shell*|Run shell **without** `-l` option **but with** `-i` option.|
|**Non-interactive** + **Login** *shell*|Run shell **without** `-i` option **but with** `-l` option.|
|**Non-interactive** + **Non-login** *shell*|Run shell **without** `-l` option and **without** `-i` option.|

<br>

Is this shell **interactive**? Check the contents of the `$-` variable: for **interactive** shells, it will contain **i**.<br>
Is this a **login** shell? There is **no** portable way of checking this but, for **bash** and **sh** check the **login_shell** option: for **login** shells it is set to **on**.<br>

<br>

## Interactive, non-login shell
```bash
$ echo $-; shopt login_shell
himBH
login_shell    	off
```

<br>

## Interactive login shell
```bash
$ bash -l
$ echo $-; shopt login_shell
himBH
login_shell    	on
```

<br>

## Non-interactive, non-login shell
```bash
$ bash -c 'echo $-; shopt login_shell'
hBc
login_shell    	off
```

<br>

## Non-interactive login shell
```bash
$ bash -l -c 'echo $-; shopt login_shell'
hBc
login_shell    	on
```

<br>

# Startup files
**Diffirent** *shells* read different **startup files** in **different** *modes*.<br>

<br>

## sh
|**File**|**System wide**|**Local**|
|:-------|:----------------------|:----------------|
|**profile**|`/etc/profile`|**No**|
|**bashrc**|`/etc/bash.bashrc` in Linux or `/etc/bashrc` in MacOS|**No**|

<br>

## bash
|**File**|**System wide**|**Local**|
|:-------|:----------------------|:----------------|
|**profile**|`/etc/profile`|**first** existing file:<br>- `~/.bash_profile`<br>- **then** `~/.bash_login`<br>- **then** `~/.profile`|
|**bashrc**|- `/etc/bash.bashrc` in Linux<br>- `/etc/bashrc` in MacOS|`~/.bashrc`|

<br>

## `zsh`
|**File**|**System wide**|**Local**|
|:-------|:----------------------|:----------------|
|**zshenv**|`/etc/zshenv`|`~/.zshenv`|
|**zprofile**|`/etc/zprofile`|`~/.zprofile`|
|**zshrc**|`/etc/zshrc`|`~/.zshrc`|

<br>

# Prepare files for examples
### `~/test.sh`
```bash
anton@test:~ [] $ cat ~/test.sh
#!/bin/sh
echo "HELLO from TEST!"
echo '$0'=$0
echo '$SHELL'=$SHELL
anton@test:~ [] $
```

<br>

### `~/.shrc`
```bash
anton@test:~ [] $ cat ~/.shrc
echo "Reading '~/.shrc' ..."

if [ -f ~/.settings/rc ]; then
  . ~/.settings/rc
fi
anton@test:~ [] $
```

<br>

### `~/.bashrc`
```bash
anton@test:~ [] $ cat ~/.bashrc
echo "Reading '~/.bashrc' ..."

if [ -f ~/.settings/rc ]; then
  . ~/.settings/rc
fi
anton@test:~ [] $
```

<br>

### `~/.zshrc`
```bash
anton@test:~ [] $ cat ~/.zshrc
echo "Reading '~/.zshrc' ..."

if [ -f ~/.settings/rc ]; then
  . ~/.settings/rc
fi
anton@test:~ [] $
```

<br>

### `~/.profile`
```bash
anton@test:~ [] $ cat ~/.profile
echo "Reading '~/.profile' ..."

if [ -f ~/.settings/profile ]; then
  . ~/.settings/profile
fi
anton@test:~ [] $
```

<br>

### `~/.zprofile`
```bash
anton@test:~ [] $ cat ~/.zprofile
echo "Reading '~/.zprofile' ..."

if [ -f ~/.settings/profile ]; then
  . ~/.settings/profile
fi

autoload -U colors && colors
autoload -Uz compinit && compinit
anton@test:~ [] $
```

<br>

# Order of reading startup files
## sh
|Mode|Files|
|:---|:----|
|**Non-login** + **Non-interactive**|**Doesn't** read **any** files in `~` directory.|
|**Non-login** + **Interactive**|Takes path in **variable** `ENV` and reads that file.|
|**Login** + **Non-interactive**|Reads only `~/.profile`.|
|**Login** + **Interactive**|Reads `~/.profile` **first**, then takes path in **variable** `ENV` and reads that file.|

<br>

### Non-Login and Interactive mode
```bash
anton@test:~ [] $ sh
sh-3.2$
```

<br>

```bash
anton@test:~ [] $ sh -i
sh-3.2$ exit
anton@test:~ [] $
```

<br>

```bash
anton@test:~ [] $ export ENV=~/.shrc
anton@test:~ [] $ sh
Reading '~/.shrc' ...
Reading '~/.settings/rc' ...
sh-3.2$
```



<br>

### Login and Interactive mode
```bash
anton@test:~ [] $ sh -l
Reading '/etc/profile' ...
Reading '/etc/bashrc' ...
Reading '~/.profile' ...
Reading '~/.settings/profile' ...
anton@test:~ [] $
```

<br>

```bash
anton@test:~ [] $ sh -l -i
Reading '/etc/profile' ...
Reading '/etc/bashrc' ...
Reading '~/.profile' ...
Reading '~/.settings/profile' ...
anton@test:~ [] $
```

<br>

```bash
anton@test:~ [] $ export ENV=~/.shrc
anton@test:~ [] $ sh -l
Reading '/etc/profile' ...
Reading '/etc/bashrc' ...
Reading '~/.profile' ...
Reading '~/.settings/profile' ...
Reading '~/.shrc' ...
Reading '~/.settings/rc' ...
anton@test:~ [] $
```

<br>

### Login and Non-interactive mode
```bash
anton@test:~ [] $ sh -l test.sh
Reading '/etc/profile' ...
Reading '/etc/bashrc' ...
Reading '~/.profile' ...
Reading '~/.settings/profile' ...
HELLO from TEST!
$0=test.sh
$SHELL=/bin/sh
anton@test:~ [] $
```

<br>

```bash
anton@test:~ [] $ sh -l test.sh
Reading '/etc/profile' ...
Reading '/etc/bashrc' ...
Reading '~/.profile' ...
Reading '~/.settings/profile' ...
HELLO from TEST!
$0=test.sh
$SHELL=/bin/sh
anton@test:~ [] $
```

<br>

### Non-login and Non-interactive mode
```bash
anton@test:~ [] $ sh test.sh
HELLO from TEST!
$0=test.sh
$SHELL=/bin/sh
anton@test:~ [] $
```

<br>

```bash
anton@test:~ [] $ export ENV=~/.shrc
anton@test:~ [] $ sh test.sh
HELLO from TEST!
$0=test.sh
$SHELL=/bin/sh
anton@test:~ [] $
```

<br>

## bash
|**Mode of shell**|**Order**|
|:----------------|:--------|
|**Login**|- `/etc/profile`<br>- `/etc/bash.bashrc`<br>- **first** existing file: `~/.bash_profile` -> `~/.bash_login` -> `~/.profile`|
|**Non-login**|- `/etc/bash.bashrc`<br>- `~/.bashrc`|

<br>

After **logout** with **exit** command, ``bash`` sources file: `~/.bash_logout`.

<br>

### Non-Login and Interactive mode
```bash
anton@test:~ [] $ bash -i
Reading '~/.bashrc' ...
Reading '~/.settings/rc' ...
anton@test:~ [] $
```

<br>

```bash
anton@test ~ % bash
Reading '~/.bashrc' ...
Reading '~/.settings/rc' ...
%n@%m %1~ %#
```

<br>

### Login and Interactive mode
```bash
anton@test:~ [] $ bash -l -i
Reading '/etc/profile' ...
Reading '/etc/bashrc' ...
Reading '~/.profile' ...
Reading '~/.settings/profile' ...
anton@test:~ [] $
```

<br>

### Login and Non-interactive mode
```bash
anton@test:~ [] $ bash -l test.sh
Reading '/etc/profile' ...
Reading '/etc/bashrc' ...
Reading '~/.profile' ...
Reading '~/.settings/profile' ...
HELLO from TEST!
$0=test.sh
$SHELL=/bin/bash
anton@test:~ [] $
```

<br>

### Non-login and Non-interactive mode
```bash
anton@test:~ [] $ bash test.sh
HELLO from TEST!
$0=test.sh
$SHELL=/bin/bash
anton@test:~ [] $
```

<br>

## zsh
### Non-Login and Interactive mode
```bash
anton@test:~ [] $ zsh
Reading '/etc/zshenv' ...
Reading '~/.zshenv' ...
Readin '/etc/zshrc' ...
Reading '~/.zshrc' ...
Reading '~/.settings/rc' ...
anton@test ~ %
```

<br>

### Login and Interactive mode
```bash
anton@test ~ % zsh -l
Reading '/etc/zshenv' ...
Reading '~/.zshenv' ...
Reading '/etc/zprofile' ...
Reading '~/.zprofile' ...
Reading '~/.settings/profile' ...
Reading '/etc/zshrc' ...
Reading '~/.zshrc' ...
Reading '~/.settings/rc' ...
anton@test ~ %
```

<br>

```bash
anton@test ~ % zsh -l -i
Reading '/etc/zshenv' ...
Reading '~/.zshenv' ...
Reading '/etc/zprofile' ...
Reading '~/.zprofile' ...
Reading '~/.settings/profile' ...
Reading '/etc/zshrc' ...
Reading '~/.zshrc' ...
Reading '~/.settings/rc' ...
anton@test ~ %
```

### Login and Non-interactive mode
```bash
anton@test:~ [] $ zsh -l test.sh
Reading '/etc/zshenv' ...
Reading '~/.zshenv' ...
Reading '/etc/zprofile' ...
Reading '~/.zprofile' ...
Reading '~/.settings/profile' ...
HELLO from TEST!
$0=test.sh
$SHELL=/bin/sh
anton@test:~ [] $
```

<br>

### Non-login and Non-interactive mode
```bash
anton@test:~ [] $ zsh test.sh
Reading '/etc/zshenv' ...
Reading '~/.zshenv' ...
HELLO from TEST!
$0=test.sh
$SHELL=/bin/sh
anton@test:~ [] $
```
