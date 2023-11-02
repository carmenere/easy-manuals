# OpenRC
## Services
**Start**, **stop** and **restart** service named `foo`:
- `/etc/init.d/foo start`
- `/etc/init.d/foo stop`
- `/etc/init.d/foo restart`

<br>

`rc-status`
Shows which services are running

`rc-service`
Locate and run an OpenRC service



`/etc/init.d`
Scripts to run OpenRC

`/etc/rc.d`
Scripts automatically executed at boot and shutdown

ca


`/etc/rc.conf`
The global OpenRC configuration file

`/etc/defaults/rc.conf`
Specifies the default settings for all the available options.


`/etc/conf.d`
Initscript Configuration Files




Is this the same as … ?
$ rc-service foo start
Init scripts
Init scripts are somewhat similar to sysvinit scripts used in sysvinit. However, some several simplify their creation.
The initscript for the service named foo is /etc/init.d/foo.
Init scripts are apparently interpreted by openrc-run.
Configuration file
The configuration file for the init script /etc/init.d/foo is /etc/conf.d/foo.
TODO
$ rc-status
The files under {/mnt/livecd,}/lib/rc/sh/
See also
/etc/rc.conf stores the *global OpenRC configruation settings.
/var/log/rc.log is the default log file.
The runlevels under /etc/runlevels have symlinks to the actual init scripts.
/lib/rc/sh/openrc-run.sh (in a live cd located under /mnt/livecd/…) is a shell warapper for openrc-run.