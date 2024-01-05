# Ubuntu repository
## Apt
Ubuntu uses `apt` for package management.<br>
`apt` stores a **list of repositories** 
- in the file `/etc/apt/sources.list`;
- in any file with the suffix `.list` under the directory `/etc/apt/sources.list.d/`, e.g. `/etc/apt/sources.list.d/<repository-file-name>.list`;

<br>

Each **repository entry** in the `.list` file specifies:
- the **type of packages** (**precompiled packages** or **source code**);
- **location** of the repository;
- the **release code name** (i.e., focal, bionic. etc);
- the **sections** of packages available in that repository (`main`, `restricted`, `universe`, `multiverse`) ;

<br>

Also **release code name** can have **components**.<br>
Ubuntu publishes **updates** to **2 different components**:
- `<code_name>-updates` conatains updates for serious **bugs**;
- `<code_name>-security` conatains important **security updates**, they are managed by the **Ubuntu Security Team**;

<br>

**Backporting** is the action of taking parts from a newer version of a software and porting them to an older version of the same software.
It is commonly used for **providing new features to older versions**.

<br>

#### Example
```bash
deb http://ru.archive.ubuntu.com/ubuntu/ xenial main restricted
deb-src http://ru.archive.ubuntu.com/ubuntu/ xenial main restricted

deb http://ru.archive.ubuntu.com/ubuntu/ xenial-updates main restricted
deb-src http://ru.archive.ubuntu.com/ubuntu/ xenial-updates main restricted

deb http://ru.archive.ubuntu.com/ubuntu/ xenial-security main restricted
deb-src http://ru.archive.ubuntu.com/ubuntu/ xenial-security main restricted

deb http://archive.ubuntu.com/ubuntu xenial universe multiverse
deb-src http://archive.ubuntu.com/ubuntu xenial universe multiverse

deb http://archive.ubuntu.com/ubuntu xenial-updates universe multiverse
deb-src http://archive.ubuntu.com/ubuntu xenial-updates universe multiverse

deb http://archive.ubuntu.com/ubuntu xenial-security universe multiverse
deb-src http://archive.ubuntu.com/ubuntu xenial-security universe multiverse
```

<br>

## Ubuntu repo layout
Ubuntu repo layout:
```bash
dists/
indices/
ls-lR.gz
pool/
project/
ubuntu/
```

<br>

The `pool` directory contains the actual `.deb` files.<br>
The organization is `/pool/[section]/[first_letter]/[group]/packagename.deb`.<br>

<br>

The `pool` directory layout:
```bash
main/
multiverse/
restricted/
universe/
```

<br>

## Sections of packages
All Ubuntu repositories are divided into **four** sections of packages:
- `main`;
- `restricted`;
- `universe`;
- `multiverse`;

Sections contain **different types** of software packages.

<br>

|Category|Description|
|:-------|:----------|
|`Main`|**Officially supported**, Free and Open-Source Software (**FOSS**).<br>This section is **enabled by default**.|
|`Restricted`|**Officially supported** software that is **not FOSS**.<br>The Restricted section is dedicated to **hardware-related software**, which often has **proprietary components** and **closed source**.|
|`Universe`|**Community maintained** (not officially supported), Free and Open-Source Software (**FOSS**).|
|`Multiverse`|**Community maintained** (not officially supported) software that is **not FOSS**.|

<br>

## Launchpad Personal Package Archive
**Launchpad** is a **web service** that allows to developers publish their own repositories (called **PPA**/**Personal Package Archives**) which users can add to `sources.list`.<br> In other words **Launchpad** is a **web service** that hosts PPAs.<br>
**Launchpad PPA** allow users to easily install and/or upgrade packages that are **unavailable in the official package repositories**.<br>

<br>

# Managing Ubuntu repositories
## Adding repositories
```bash
sudo apt-add-repository <repository-URL>
```

<br>

## Adding Launchpad PPA repositories
```bash
sudo add-apt-repository ppa:<repository-name>
```

<br>

## Removing repositories
```bash
sudo apt-add-repository --remove <repository-URL>
```

<br>

## Disabling repositories
To **disable** one of the repositories, just **comment out** or **remove** the corresponding repository lines from the appropriate configuration files.

<br>

## Updating repositories
After **making a modification** to **repo list**, you always need to u**pdate the package list** to reflect the changes.<br>
```bash
sudo apt update
```
