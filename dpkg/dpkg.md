Main `dpkg` options
|Option|Description|
|:-----|:----------|
|`dpkg -l <package-name-pattern>`|Lists packages matching given pattern.|
|`dpkg -s package-name`|Reports status of specified package.|
|`dpkg -L package-name`|Lists files installed to your system from package-name.|
|`dpkg -S <abs-path-to-file>`|Finds what package a file belongs to, i.e., outputs mapping between package and file `<abs-path-to-file>`.|
|`dpkg -p package-name`|Display details about package-name.<br>Users of APT-based frontends should use `apt-cache` show package-name instead.|

<br>

In `alpine` equivalent of `dpkg -S <abs-path-to-file>` is `apk info --who-owns /sbin/lbu`.
