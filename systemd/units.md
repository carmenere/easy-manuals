After the Linux kernel initialization is completed, the init script executes the program /sbin/init. 
(In the case of systemd, /sbin/init is actually a symbolic link to another file /usr/lib/systemd/systemd.)
The systemd version of init reads a series of files from the directories /etc/systemd/system and /usr/lib/systemd/system.
Each of these files is called a "unit" and units can be of various types such as service, target, etc., as indicated by the filename suffix (.service, .target, etc.)
A "service" is typically a daemon that runs in the background to perform some system function.



System Unit Search Path
/etc/systemd/system.control/*
/run/systemd/system.control/*
/run/systemd/transient/*
/run/systemd/generator.early/*
/etc/systemd/system/*
/etc/systemd/system.attached/*
/run/systemd/system/*
/run/systemd/system.attached/*
/run/systemd/generator/*
…
/usr/lib/systemd/system/*
/run/systemd/generator.late/*


systemctl list-units
systemctl list-units --type=target
systemctl list-units --type=service



Service unit files may include [Unit] and [Install] sections, which are described in systemd.unit(5).

Service unit files must include a [Service] section, which carries information about the service and the process it supervises. 

To see the actual list that would be used based on compilation options and current environment use

systemd-analyze --user unit-paths
systemd-analyze --system unit-paths


Unit files found in directories listed earlier override files with the same name in directories lower in the list.

the /etc/systemd/system/ directory is reserved for unit files created or customized by the system administrator
For example, there usually is sshd.service as well as sshd.socket unit present on your system.


Also, the sshd.service.wants/ and sshd.service.requires/ directories can be created. These directories contain symbolic links to unit files that are dependencies of the sshd service. The symbolic links are automatically created either during installation according to [Install] unit file options or at runtime based on [Unit] options. It is also possible to create these directories and symbolic links manually. For more details on [Install] and [Unit] options, see the tables below.


Unit file structure
Unit files typically consist of three sections:

The [Unit] section — contains generic options that are not dependent on the type of the unit. 

The [Install] section — contains information about unit installation used by systemctl enable and disable commands. 

In addition to the generic [Unit] and [Install] sections described here, each unit may have a type-specific section, e.g. [Service] for a service unit.



Important [Unit] section options:
Requires The units listed in Requires are activated together with the unit. dependencies on other units. If any of the required units fail to start, the unit is not activated.
Wants like Requires but is weaker than Requires.

After Defines the order in which units are started. The unit starts only after the units specified in After are active. Unlike Requires, After does not explicitly activate the specified units.



 Important [Service] section options
 Type type of service
* simple – The default value. The process started with ExecStart is the main process of the service.
* forking – The process started with ExecStart spawns a child process that becomes the main process of the service. The parent process exits when the startup is complete. Type=forking is used for daemons that make the fork system call. 
* oneshot – This type is similar to simple, but the process exits before starting consequent units, useful, for at start time scripts.
* dbus – This type is similar to simple, but consequent units are started only after the main process gains a D-Bus name.
* notify – This type is similar to simple, but consequent units are started only after a notification message is sent via the sd_notify() function.
* idle – similar to simple.

 ExecStart Specifies commands or scripts to be executed when the unit is started.
 ExecStop Specifies commands or scripts to be executed when the unit is stopped.
 ExecReload Specifies commands or scripts to be executed when the unit is reloaded.
 Restart With this option enabled, the service is restarted after its process exits, with the exception of a clean stop by the systemctl command.


Important [Install] section options

Alias Provides a space-separated list of additional names for the unit. Most systemctl commands, excluding systemctl enable, can use aliases instead of the actual unit name.

RequiredBy A list of units that depend on the unit. When this unit is enabled, the units listed in RequiredBy gain a Require dependency on the unit.

WantedBy A list of units that weakly depend on the unit. When this unit is enabled, the units listed in WantedBy gain a Want dependency on the unit.
WantedBy states the target or targets that the service should be started under. Think of these targets as of a replacement of the older concept of runlevels.

Also Specifies a list of units to be installed or uninstalled along with the unit.

DefaultInstance Limited to instantiated units, this option specifies the default instance for which the unit is enabled. See Working with instantiated units.



Always run the systemctl daemon-reload command after creating new unit files or modifying existing unit files. Otherwise, the systemctl start or systemctl enable commands could fail due to a mismatch between states of systemd and actual service unit files on disk.

Видим, что он disabled — разрешаем его
systemctl enable myunit
systemctl -l status myunit


systemctl list-dependencies getty.target



nton@ubuntu:~$
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
anton@ubuntu:~$