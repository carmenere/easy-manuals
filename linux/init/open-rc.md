# OpenRC
## Commands
|Command|Description|
|:------|:----------|
|`/etc/init.d/foo start` or `rc-service foo start`|**Start** service `foo`.|
|`/etc/init.d/foo stop`|**Stop** service `foo`.|
|`/etc/init.d/foo restart`|**Restart** service named `foo`.|
|`rc-status`|List all services and their statuses.|

<br>

## Directories and files
|Command|Description|
|:------|:----------|
|`/etc/init.d`|**Init scripts** for services.|
|`/etc/rc.d`|Scripts automatically executed at boot and shutdown.|
|`/etc/rc.conf`|The **global** OpenRC configuration file.|
|`/etc/conf.d`|**Configuration files** for init scripts.<br>The **configuration file** for the init script `/etc/init.d/foo` is `/etc/conf.d/foo`.|
|`/etc/defaults/rc.conf`|Specifies the default settings for all the available options.|
|`/etc/runlevels`|Contains **symlinks** to the actual init scripts for every **runlevel**.|
