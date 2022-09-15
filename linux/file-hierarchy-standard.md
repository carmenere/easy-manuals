The **Filesystem Hierarchy Standard** (**FHS**) is a reference describing the conventions used for the layout of a UNIX file system.

# Executables and libraries
There are **3 directories** for executables and libs:
- ``bin``
- ``sbin``
- ``lib``
- ``share``

# ``bin``, ``sbin``, ``lib`` and ``share`` can be in:
- ``/``
- ``/usr``
- ``/usr/local``

# ``/usr/local`` vs. ``/usr``
The abbrevation ``usr`` stands for **Unix System Resources**. 
- ``/usr`` directory is used for **secondary hierarchy** and contains *binaries*, *libraries*, *documentation* installed **from distribution**.
- ``/usr/local`` directory is used for **tertiary /ˈtɜːrʃieri/ hierarchy** and contains *binaries*, *libraries*, *documentation* installed **from third-party sources**, not from the distribution.

# Other directories
|Directory|Description|
|:--------|:----------|
|``/boot``|Boot loader files (e.g., kernels, initrd).|
|``/etc``|Host-specific **system-wide** configuration files.|
|``/lib``|Libraries essential for the binaries in ``/bin`` and ``/sbin``.|
|``/lib<qual>``|Used on systems that support **more than one executable format**, e.g., systems supporting 32-bit and 64-bit instruction sets.|
|``/home``|Users' home directories, containing **saved files**, **personal settings**, etc. |
|``/media``|Mount points for removable media such as CD-ROMs |
|``/mnt``|Temporarily mounted filesystems. |
|``/opt``|Add-on application software packages.|
|``/proc``|Virtual filesystem providing process and kernel information as files.|
|``/root``|Home directory for the root user. |
|``/run``|**Run-time variable data**: Information about the running system since last boot|
|``/sys``|Contains information about **devices**, **drivers**, and **some kernel features**.|
|``/tmp``|Often not preserved between system reboots |
|``/var``|**Variable files**: files whose content is expected to continually change during normal operation of the system, such as logs, spool files, and temporary e-mail files. |
