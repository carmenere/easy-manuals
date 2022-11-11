# Modes of shell
There are 4 **modes** of shell:
|  |Login shell|Non-login shell|
|:-|:----------|:--------------|
|**Interactive shell**|- **Log** into a **remote** computer via `ssh`.<br>- **Log** into a **local** computer via `tty`.<br>- Run shell **with** `--login` or `-l` option.|Run shell **without** `--login` or `-l` option.|
|**Non-interactive shell**|**Executing** or **sourcing** a script **with** `--login` or `-l` option.|**Executing** or **sourcing** a script **without** `--login` or `-l` option.|

<br>

**Diffirent** *shells* use **different** *initial script* in **different** *modes*.

<br>

# zsh
## The **init files** for `zsh`
|**File**|**Path to system wide**|**Path to local**|
|:-------|:----------------------|:----------------|
|**zshenv**|`/etc/zshenv`|`~/.zshenv`|
|**zprofile**|`/etc/zprofile`|`~/.zprofile`|
|**zshrc**|`/etc/zshrc`|`~/.zshrc`|

<br>

## Order for zsh
|**Mode of shell**|**Order**|
|:----------------|:--------|
|**Non-interactive** + **Non-login**|`zshenv`|
|**Interactive** + **Non-login**|- `zshenv`<br>- `zshrc`|
|**Interactive** + **Login**|`zshenv`<br>`zprofile`<br>`zshrc`<br>`zlogin`|

<br>

So,
- `.zprofile` is sourced upon **login**; 
- `.zshrc` is sourced upon **starting** of a **new shell**.

<br>

# bash
## The init files for bash
|**File**|**Path to system wide**|**Path to local**|
|:-------|:----------------------|:----------------|
|**profile**|`/etc/profile`|**first** existing file: `~/.bash_profile` -> `~/.bash_login` -> `~/.profile`|
|**bashrc**|`/etc/bash.bashrc`|`~/.bashrc`|

<br>

## Order for bash
|**Mode of shell**|**Order**|
|:----------------|:--------|
|**Login**|- `/etc/profile`<br>- `/etc/bash.bashrc`<br>- **first** existing file: `~/.bash_profile` -> `~/.bash_login` -> `~/.profile`|
|**Non-login**|- `/etc/bash.bashrc`<br>- `~/.bashrc`|

<br>

After **logout** with exit cmmand, bash sources file: `~/.bash_logout`.
