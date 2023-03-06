# Systemd units
A systemd's **unit** is a **plain text ini-style file** that encodes information about a *service*, a *socket*, a *target* and so on.<br>
Valid `unit` names has following format `<name>.<unit-type>`.<br>
The `<unit-type>` must be one of `.service`, `.socket`, `.device`, `.mount`, `.automount`, `.swap`, `.target`, `.path`, `.timer`, `.slice`, or `.scope`.<br>

<br>

#### Listing units
`systemctl list-units`
`systemctl list-units --type=target`
`systemctl list-units --type=service`

<br>

## Services and Targets
**Services** (**service units**) are system **daemons**.<br>
**Targets** (**target units** ) are different **states** that your system can boot into, like to *System V* **runlevels**.<br>
**Targets** in `systemd` act as **synchronization points** during the start of your system.<br>
The purpose of **targets** is to group together various units through a chain of dependencies.<br>

To see the **current target**, use the command `systemctl get-default`.
List dependencies of target: `systemctl list-dependencies getty.target`.

<br>

## Units load path
Units are loaded from a set of paths determined during compilation.<br>
Units found in directories listed **earlier** **override** files with the same name in directories **lower** in the list (**more first more priority**):
- /etc/systemd/system/*
- /run/systemd/system/*
- /lib/systemd/system/*
- /usr/lib/systemd/system/*

<br>
3 category of units locations:
- The `/etc/systemd/system/*` directory is reserved for **units** created or customized by the administrator and **units** created by `systemctl enable`.
- The `/lib/systemd/system/*` and `/usr/lib/systemd/system/*` dirictories contain **units** distributed with installed packages.
- The `/run/systemd/system/*` contains **units** created at run time.

<br>

To see the **actual units load paths** run:
- `systemd-analyze --system unit-paths`
- `systemd-analyze --user unit-paths`

<br>

## Unit file structure
**Unit** typically consist of three sections:
- the `[Unit]` section — contains **generic options** that are not dependent on the type of the unit. 
- the `[Install]` section — contains information about unit installation used by `systemctl enable` and `systemctl disable` commands. 
- the **type-specific section**, e.g. [Service] for a service unit.

<br>

### Important `[Unit]` section options
- `Requires` The units listed in `Requires` are activated **together** with the unit. If **any** of the required units **fail to start**, the **unit** is **not activated**.
- `Wants` like `Requires` but is **weaker** than `Requires`.
- `After` Defines the **order** in which units are started. The unit starts only after the units specified in `After` are **active**. Unlike `Requires`, `After` does not explicitly activate the specified units.

<br>

### Important `[Install]` section options
`RequiredBy` A list of units that depend on the unit. When this unit is **enabled**, the units listed in `RequiredBy` gain a Require dependency on the unit.
`WantedBy` A list of units that weakly depend on the unit. When this unit is enabled, the units listed in `WantedBy` gain a Want dependency on the unit.
`WantedBy` states the target or targets that the service should be started under. Think of these targets as of a replacement of the older concept of runlevels.
Also Specifies a list of units to be installed or uninstalled along with the unit.
`DefaultInstance` Limited to instantiated units, this option specifies the default instance for which the unit is enabled. See Working with instantiated units.

<br>

### Important `[Service]` section options
1. `Type` determines type of service
   - `simple` – The default value. The process started with `ExecStart` is the main process of the service.
   - `forking` – The process started with `ExecStart` spawns a child process that becomes the main process of the service. The parent process exits when the startup is complete. `Type=forking` is used for daemons that make the `fork` system call.
   - `oneshot` – This type is similar to simple, but the process exits before starting consequent units, useful, for at start time scripts.
   - `dbus` – This type is similar to simple, but consequent units are started only after the main process gains a **D-Bus** name.
   - `notify` – This type is similar to simple, but consequent units are started only after a notification message is sent via the sd_notify() function.
   - `idle` – similar to simple.
2. `ExecStart` specifies commands or scripts to be executed when the unit is started.
3. `ExecStop` specifies commands or scripts to be executed when the unit is stopped.
4.`ExecReload` specifies commands or scripts to be executed when the unit is reloaded.
5. `Restart` with this option enabled, the service is restarted after its process exits, with the exception of a clean stop by the systemctl command.

<br>

## Unit for getty@.service
```bash
anton@ubuntu:~$ cat /lib/systemd/system/getty@.service
#  SPDX-License-Identifier: LGPL-2.1-or-later
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=Getty on %I
Documentation=man:agetty(8) man:systemd-getty-generator(8)
Documentation=http://0pointer.de/blog/projects/serial-console.html
After=systemd-user-sessions.service plymouth-quit-wait.service getty-pre.target
After=rc-local.service

# If additional gettys are spawned during boot then we should make
# sure that this is synchronized before getty.target, even though
# getty.target didn't actually pull it in.
Before=getty.target
IgnoreOnIsolate=yes

# IgnoreOnIsolate causes issues with sulogin, if someone isolates
# rescue.target or starts rescue.service from multi-user.target or
# graphical.target.
Conflicts=rescue.service
Before=rescue.service

# On systems without virtual consoles, don't start any getty. Note
# that serial gettys are covered by serial-getty@.service, not this
# unit.
ConditionPathExists=/dev/tty0

[Service]
# the VT is cleared by TTYVTDisallocate
# The '-o' option value tells agetty to replace 'login' arguments with an
# option to preserve environment (-p), followed by '--' for safety, and then
# the entered username.
ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear %I $TERM
Type=idle
Restart=always
RestartSec=0
UtmpIdentifier=%I
TTYPath=/dev/%I
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
IgnoreSIGPIPE=no
SendSIGHUP=yes

# Unset locale for the console getty since the console has problems
# displaying some internationalized messages.
UnsetEnvironment=LANG LANGUAGE LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT LC_IDENTIFICATION

[Install]
WantedBy=getty.target
DefaultInstance=tty1
```

<br>

## systemctl daemon-reload
> Always run the `systemctl daemon-reload` command after creating new unit files or modifying existing unit files.
> Otherwise, the `systemctl start` or `systemctl enable` commands could **fail** due to a mismatch between states of `systemd` and actual service unit files on disk.

<br>

## Example: run `iptables-restore` at boot
### Iptables rules
```bash
cat <<EOF1 > /etc/iptables-restore-DOCKER-USER.conf
# Generated by iptables-save v1.6.0 on Fri Aug 10 13:04:02 2018
*filter
:DOCKER-USER - [0:0]
-I DOCKER-USER -s 192.168.88.0/24 -p tcp -m multiport --dports 22,80,443,8080,8888 -j ACCEPT
-I DOCKER-USER -s 192.168.25.0/24 -p tcp -m multiport --dports 22,80,443,8080,8888 -j ACCEPT
-A DOCKER-USER -j RETURN
COMMIT
# Completed on Fri Aug 10 13:04:02 2018
EOF1
```

<br>

### Service unit
```bash
cat <<EOF2 > /lib/systemd/system/iptables-restore-DOCKER-USER.service
[Unit]
Description=Restore iptables firewall rules
After=docker.service
[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore -n /etc/iptables-restore-DOCKER-USER.conf
[Install]
WantedBy=multi-user.target
EOF2
```

<br>

### `enable`, `reload` and `start`
```bash
systemctl enable iptables-restore-DOCKER-USER.service
systemctl daemon-reload
systemctl start iptables-restore-DOCKER-USER.service
```
