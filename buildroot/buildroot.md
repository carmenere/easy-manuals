# Buildroot
**Buildroot** is a framework for building embedded Linux distribution.<br>
**Buildroot** is used to compile a complete Linux distribution (including *boot*, *kernel*, *rootfs*, and various *libraries* and *applications* in rootfs) for the **board** it was configured for.<br>

<br>

# Getting Buildroot
Stable Buildroot releases are published every three months: `YYYY.02`, `YYYY.05`, `YYYY.08`, `YYYY.11`.<br>
Download `buildroot src`: `git clone https://git.buildroot.net/buildroot`.
Here and further `buildroot src` is the top-level Buildroot source directory.

<br>

# Configuring Buildroot
Like the Linux kernel, Buildroot uses `Kconfig` language and supplies various *configuration interfaces*, e.g., `make menuconfig` (graphical menu using **ncurses**).<br>
The **configuration file** is the `.config` file in `buildroot src`.<br>
The `.config` file is a **full config file**: it contains the value for **all options**.<br>
The **default** `.config`, without any customization, has **4467** lines (as of Buildroot 2021.02).<br>

<br>

## defconfig
A `defconfig` stores only the **non-default** values.<br>
For the default Buildroot configuration, the `defconfig` is empty: everything is the default.<br>
If you change the architecture to be **ARM**, the `defconfig` is just one line: 
```bash
BR2_arm=y
```

<br>

To use a `defconfig`, copying it to `.config` is not sufficient as all the missing (default) options need to be expanded.<br>
Buildroot allows to load `defconfig` stored in the `configs/` directory, by doing: `make <foo>_defconfig`. It **overwrites** the current `.config`, if any.<br>
If `make xxx_defconfig` was run as first creates your initial `.config`, which you can now edit through `make menuconfig` and make your changes.<br>

To save current settings as `defconfig` file run `make savedefconfig`.
`make savedefconfig` uses `BR2_DEFCONFIG` configuration option from `.config` file (ver `BR2_CONFIG` in top-level `Makefile`).<br>
`BR2_DEFCONFIG` stores **abs path** to `defconfig` file.<br>
- `BR2_DEFCONFIG` points to the **original** `defconfig` if the configuration was loaded **from** a `defconfig` (e.g., `make menuconfig` was first);
- `BR2_DEFCONFIG` points to `defconfig` in the current directory if the configuration was started **from scratch** (e.g., `make xxx_defconfig` was first);
- it is possible pass arbitrary path throgh `BR2_DEFCONFIG`:

```bash
make savedefconfig BR2_DEFCONFIG=%abs_path_to_defconfig%
```

<br>

Move `defconfig` file to `configs/` to make it loadable with `make xxx_defconfig`.

<br>

### Examples
#### BR2_DEFCONFIG value in .config file
```bash
$ grep BR2_DEFCONFIG .config
BR2_DEFCONFIG="/tmp/buildroot/configs/qemu_aarch64_virt_defconfig"
```

<br>

#### Snippet from top-level `Makefile`:
The Buildroot `.config` file is a succession of lines `name = value`. This file is **valid make syntax**!<br>
The main Buildroot Makefile simply includes `.config` file, which turns every Buildroot configuration option into a make variable.<br>

```makefile
# ...

# Set variables related to in-tree or out-of-tree build.
# Here, both $(O) and $(CURDIR) are absolute canonical paths.
ifeq ($(O),$(CURDIR)/output)
CONFIG_DIR := $(CURDIR)
NEED_WRAPPER =
else
CONFIG_DIR := $(O)
NEED_WRAPPER = y
endif

# ...

BR2_CONFIG = $(CONFIG_DIR)/.config

include $(BR2_CONFIG)

# ...

DEFCONFIG = $(call qstrip,$(BR2_DEFCONFIG))

savedefconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) $< \
		--savedefconfig=$(if $(DEFCONFIG),$(DEFCONFIG),$(CONFIG_DIR)/defconfig) \
		$(CONFIG_CONFIG_IN)
	@$(SED) '/^BR2_DEFCONFIG=/d' $(if $(DEFCONFIG),$(DEFCONFIG),$(CONFIG_DIR)/defconfig)

# ...
```

<br>

## Predefined defconfigs
Buildroot comes with a number of **existing defconfigs** for various publicly available hardware platforms:
- RaspberryPi
- Microchip
- QEMU emulated platforms
- ...

<br>

`make list-defconfigs` lists all **existing defconfigs** using.<br>
Additional instructions often available in `board/<boardname>`.

<br>

# Build
As simple as
```bash
make
```

<br>

Often useful to **keep a log of the build output**, for analysis or investigation: 
```bash
$ make 2>&1 | tee build.log
```

<br>

## Build results
By default, **output directory** is `output/` within the `buildroot src`.<br>

<br>

## Build tree
`$(O)` contains **output directory**.
- `$(O)/build`: this directory contains all package source code;
- `$(O)/host`: tools required for host-side compilation include cross-compilation tools;
- `$(O)/staging`: contains the **complete** *root filesystem*, compared to `target/`, it has development files, header files, and the binary files are not **stripped**;
- `$(O)/target`: contains the **complete** *root filesystem*, compared to `staging/`, it has **no** development files, **no** header files, and the binary files are **stripped**;
- `$(O)/images`: contains a **compressed** *root filesystem* image file.

<br>

### `$(O)/images`
Depending on the configuration, `output/images` directory will contain:
- One or several **root filesystem images**, in various formats;
- One **kernel image**;
- Zero or several `.dtb` files;
- One or several **bootloader images**;

<br>

## Out-of-tree build
**Out-of-tree build** allows to use an arbitrary **output directory**.<br>
It is useful to build different Buildroot configurations from the same source tree.<br>
**Output directory** is customized by passing `O=<dir>` on the command line.<br>
Once one out of tree operation has been done (menuconfig, loading a defconfig, etc.), Buildroot creates a small **wrapper Makefile** in the output directory.<br>
This **wrapper Makefile** then avoids the need to pass `O=` and the path to the Buildroot source tree.

<br>

## Rebuild
### Rebuild the package
During the development process, if the source code of a certain package is modified, Buildroot will not recompile the package.

#### Method one
`make <package>-rebuild`

<br>

#### Method two
```bash
# Delete the compiled output directory of the package
rm -rf output/rockchip_rk3399/build/<package>-<version>

# Compile
make <package>
```

<br>

### Full rebuild
#### Method one
Directly **delete** the output directory `rm -rf output/` and then **re-configure** and **compile**.

<br>

#### Method two
```bash
make clean all
```

<br>

# Buildroot source tree
|File or directory|Description|
|:----------------|:----------|
|`Makefile`|The top-level `Makefile`, handles the configuration and general orchestration of the build.|
|`Config.in`|The top-level `Config.in`, includes many **other** `Config.in` files.|
|`arch/`|Contains `Config.in` files for various architectures.|
|`toolchain/`|Packages for generating or using toolchains.|
|`system/skeleton/`|The `rootfs` **skeleton**.|
|`linux/`|Linux package.|
|`package/`|All the user space packages.|
|`fs`|Logic to generate **filesystem images** in various formats (`cpio/`, `ext2/`, `squashfs/`, `tar/`, `ubifs/`, etc).|
|`boot/`|**Bootloader** packages.|
|`configs/`|Default **configuration files** for various platforms (boards), similar to kernel defconfigs.|
|`board/`|Board-specific files (kernel configuration files, kernel patches, image flashing scripts, etc.)|
|`support/`|Misc utilities.|
|`utils/`|Various utilities useful to Buildroot developers.|
|`docs/`|Buildroot documentation.|

<br>

#### Download location

<br>

#### Managing the Linux kernel configuration
The **Linux kernel** itself uses kconfig to define its configuration.<br>
Buildroot cannot replicate all **Linux kernel** configuration options in its `menuconfig`.<br>
Defining the **Linux kernel** configuration therefore needs to be done in a special way.

<br>

Running one of the **Linux kernel** configuration interfaces:
- `make linux-menuconfig`
- `make linux-nconfig`
- `make linux-xconfig`
- `make linux-gconfig`

<br>

# Root filesystem in Buildroot
## Root filesystem skeleton
The base of a Linux root filesystem: UNIX directory hierarchy, a few configuration files and scripts in /etc. No programs or libraries.
All **target packages** depend on the **skeleton package**.<br>
**Skeleton package** is essentially the first thing copied to `$(TARGET_DIR)` at the beginning of the build.<br>
skeleton is a virtual package that will depend on:
- `skeleton-init-{sysv,systemd,openrc,none}` depending on the **init system** being selected;
- `skeleton-custom` when a custom skeleton is selected.

<br>

Buildroot supports multiple init implementations:
- `BusyBox init`, the **default**;
- `sysvinit`;
- `systemd`;
- `OpenRC` (the init system used by Gentoo).

<br>

When packages want to install a program to be started at boot time, they need to install a *startup script* (sysvinit/BusyBox), a *systemd service file*, *etc*.<br>
They can do so using the following variables, which contain a list of shell commands.
- `<pkg>_INSTALL_INIT_SYSV`;
- `<pkg>_INSTALL_INIT_SYSTEMD`;
- `<pkg>_INSTALL_INIT_OPENRC`;

<br>

```bash
define BIND_INSTALL_INIT_SYSV
    $(INSTALL) -m 0755 -D package/bind/S81named $(TARGET_DIR)/etc/init.d/S81named
endef
```

<br>

A custom skeleton can be used, through the `BR2_ROOTFS_SKELETON_CUSTOM`.

<br>

## Installation of packages
All the selected **target packages** will be built.<br>
Most of them will install files in `$(TARGET_DIR)`: **programs**, **libraries**, **fonts**, **data files**, **configuration files**, etc.<br>
This is really the step that will bring the vast majority of the files in the **root filesystem**.<br>
Once all packages have been installed, a **cleanup step** is executed to reduce the size of the **root filesystem:**
- **header** files, **pkg-config** files, **CMake** files, **static** libraries, **man** pages, **documentation** are removed;
- all the binaries and libraries are **stripped** to remove unneeded information.

<br>

## Root filesystem overlay
A **root filesystem overlay** is simply a directory whose contents will be copied over the **root filesystem**, after all packages have been installed.<br>
Overwriting files is allowed.<br>
To enable **root filesystem overlay**, set config option `BR2_ROOTFS_OVERLAY` (in the configuration menu `make menuconfig`).<br>
The option `BR2_ROOTFS_OVERLAY` can contain a space-separated list of **overlay paths**.<br>

<br>

### Example
Suppose, `BR2_ROOTFS_OVERLAY=board/rockchip/rk3399/fs-overlay/`.<br>

1. Add files to the `BR2_ROOTFS_OVERLAY` directory:<br>
```bash
cd buildroot/board/rockchip/rk3399/fs-overlay/
mkdir etc/
touch etc/test
```

<br>

2. Compile:
```sh
make
```

<br>

# Download infrastructure in Buildroot
One important aspect of Buildroot is to fetch source code or binary files from third party projects.<br>
**Download infrastructure** in Buildroot can fetch the source code using different methods:
- `wget`, for FTP/HTTP downloads
- `scp`, to fetch the tarball using SSH/SCP 
- `svn`, for Subversion
- `cvs`, for CVS
- `git`, for Git
- `hg`, for Mercurial
- `bzr`, for Bazaar
- `file`, for a local tarball
- `local`, for a local directory

<br>

Package lookup order:
1. The **local** `$(DL_DIR)` directory where downloaded files are kept.
2. The **primary site**, as indicated by `BR2_PRIMARY_SITE`.
3. The **original site**, as indicated by the package's `.mk` file
4. The **backup Buildroot mirror**, as indicated by `BR2_BACKUP_SITE`.

<br>

Once a file has been downloaded by Buildroot, it is cached in the directory pointed by `$(DL_DIR)`, in a sub-directory with name of `package`.<br>
`DL_DIR` can be changed by passing the `BR2_DL_DIR` environment variable.<br>
**No cleanup mechanism**: files are only added, never removed, even when the package version is updated.<br>

<br>

### File integrity checking
- Buildroot packages can provide a `.hash` file to provide hashes for the downloaded files.
- The download infrastructure uses this hash file when available to check the integrity of the downloaded files.
- Hashs are checked **every time** a downloaded file is used, even if it is already cached in `$(DL_DIR)`.

<br>

# Packages
A **package** in Buildroot-speak is the **set of meta-information** needed to **automate** the **build** process of a **certain component of a system**.<br>
Can be used for `open-source`, `third party proprietary components`, or `in-house components`.<br>

<br>

## Package layout
Consider package `<pkg>`. It must be located in directory `package/<pkg>`.<br>
Directory `package/<pkg>` contains:
- `Config.in` file, written in **kconfig language**, describing the configuration options for the package;
- `<pkg>.mk` file, describing where to **fetch** the source, how to **build** and **install** it, etc.
- optional `<pkg>.hash` file;
- ...

<br>

**kconfig** allows to express dependencies using `select` or `depends on` statements:
- `select` is an **automatic dependency**: if option `A` select option `B`, as soon as `A` is enabled, `B` will be enabled, and cannot be unselected.
- `depends on` is a **user-assisted dependency**: if option `A` `depends on` option `B`, `A` will only be visible when `B` is enabled.

<br>

A limitation of `kconfig` is that it doesn’t propagate `depends on` dependencies accross `select` dependencies.<br>
Scenario: if package `A` has a `depends on FOO`, and package `B` has a `select A`, then package `B` **must replicate** the `depends on FOO`.<br>

<br>

## Naming conventions
- The directory where the package description is located must be `package/<pkg>/`, where `<pkg>` is the **lowercase** name of the package.
- The `Config.in` option enabling the package must be named `BR2_PACKAGE_<PKG>`, where `<PKG>` is the **uppercase** name of the package.
- The variables in the `<pkg>.mk` file must be prefixed with `<PKG>_`, where `<PKG>` is the **uppercase** name of the package.

<br>

## The `package/<pkg>/Config.in` file
All `package/<pkg>/Config.in` files must be explicitly included in `package/Config.in` file.<br>
File `package/<pkg>/Config.in` has one **mandatory option** to enable/disable the package: `BR2_PACKAGE_<PACKAGE>`:

```bash
config BR2_PACKAGE_STRACE bool "strace"
help
A useful diagnostic, instructional, and debugging tool. Allows you to track what system calls a program makes while it is running.
http://sourceforge.net/projects/strace/
```

<br>

`PACKAGE` is **uppercase** name of package `<pkg>`.


<br>

## The `<pkg>.mk` file
The `<pkg>.mk` file of a package does not look like a normal Makefile.<br>
The `<pkg>.mk` file contains variables, which must be prefixed by the uppercase package name.<br>
These variables tell the **package infrastructure** what to do for this **specific package**.<br>
Example:<br>
```bash
FOOBAR_SITE = https://foobar.com/downloads/
define FOOBAR_BUILD_CMDS
    $(MAKE) -C $(@D)
endef
```

<br>

The `<pkg>.mk` file ends with a call to the desired **package infrastructure macro**.
- `$(eval $(generic-package))`
- `$(eval $(autotools-package))`
- `$(eval $(host-autotools-package))`
- ...

<br>

## The `<pkg>.mk` file variables
### Download related variables
- `<pkg>_SITE` - provides the **location of the package**, which can be a **URL** or a **local filesystem path**..
- `<pkg>_VERSION` - **mandatory** var, **version of the package**: 
  - **version of a tarball**;
  - **commit** or **tag** for version control systems;
- `<pkg>_SOURCE` - file name of the tarball;
- `<pkg>_LICENSE` defines the license (or licenses) under which the package is released.<br>
- `<pkg>_LICENSE_FILES` is a space-separated list of files in the package tarball that contain the license(s) under which the package is released.<br>

<br>

The **full URL** of the downloaded tarball is `$(<pkg>_SITE)/$(<pkg>_SOURCE)`.
When **not specified**, **defaults** to `<pkg>-$(<pkg>_VERSION).tar.gz`.

<br>

In most cases, the fetching method is guessed by Buildroot using the `<pkg>_SITE` variable.<br>
`<pkg>_SITE_METHOD` sets fetching method explicitly.<br>

<br>

### Installation locations variables
Target packages can install files to different locations:
- to the **target directory**, `$(TARGET_DIR)`, which is what will be the **target root filesystem**.
- to the **staging directory**, `$(STAGING_DIR)`, which is the **compiler sysroot**.
- to the **images directory**, `$(BINARIES_DIR)`, which is where **final images** are located.

<br>

There are 3 corresponding variables, to define whether or not the package will install something to one of these locations:
- `<pkg>_INSTALL_TARGET`, **defaults** to **YES**. If YES, then `<pkg>_INSTALL_TARGET_CMDS` will be called.
- `<pkg>_INSTALL_STAGING`, **defaults** to **NO**. If YES, then `<pkg>_INSTALL_STAGING_CMDS` will be called.
- `<pkg>_INSTALL_IMAGES`, **defaults** to **NO**. If YES, then `<pkg>_INSTALL_IMAGES_CMDS` will be called.

<br>

### Actions for generic-package variables
In a package using `generic-package`, only the **download**, **extract** and **patch** steps are implemented by the **package infrastructure**.
The other steps (**configuring**, **compiling**, **installing**) should be described by the package `.mk` file:
- `<pkg>_CONFIGURE_CMDS`, always called, lists the actions to be performed to **configure** the package before its compilation;
- `<pkg>_BUILD_CMDS`, always called;
- `<pkg>_INSTALL_TARGET_CMDS`, called when `<pkg>_INSTALL_TARGET = YES`, for **target packages**;
- `<pkg>_INSTALL_STAGING_CMDS`, called when `<pkg>_INSTALL_STAGING = YES`, for **target packages**;
- `<pkg>_INSTALL_IMAGES_CMDS`, called when `<pkg>_INSTALL_IMAGES = YES`, for **target packages**;
- `<pkg>_INSTALL_CMDS`, always called for **host packages**;
- `<pkg>_EXTRACT_CMDS` lists the actions to be performed to **extract** the package, this is needed if the package uses a **non-standard archive format**.

<br>

Packages are free to not implement any of these variables: they are all optional.<br>
The preferred way to define these variables is:
```bash
define FOO_CONFIGURE_CMDS
        action 1
        action 2
        action 3
endef
```

<br>

### Describing actions: useful variables
Some other useful variabels:
- `$(@D)` is the source directory of the package;
- `$(MAKE)` to call make;
- `$(TARGET_MAKE_ENV)` and `$(HOST_MAKE_ENV)`, to pass in the `$(MAKE)` environment;
- `$(TARGET_CONFIGURE_OPTS)` and `$(HOST_CONFIGURE_OPTS)` to pass `CC`, `LD`, `CFLAGS`, etc;
- `$(TARGET_DIR)`;
- `$(STAGING_DIR)`;
- `$(BINARIES_DIR)`;
- `$(HOST_DIR)`;

<br>

## Example of adding package
## 1. Create a project directory
`mkdir buildroot/package/rockchip/libfoo/`

<br>

## 2. Create `Config.in` file in libfoo/
`Config.in` files contain entries for almost anything configurable in Buildroot.

<br>

An entry has the following pattern:
```bash
config BR2_PACKAGE_LIBFOO
        bool "libfoo"
```

<br>

## 3. Modify the upper level `Config.in`
Add a line at the end of `buildroot/package/rockchip/Config.in`:
```bash
source "package/rockchip/libfoo/Config.in"
```

<br>

## 4. Create `libfoo.mk` in `libfoo/`
Create a file named `libfoo.mk` in `libfoo/`. It describes how the package should be **downloaded**, **configured**, **built**, **installed**, etc.<br>

```bash
01: ################################################################################
02: #
03: # libfoo
04: #
05: ################################################################################
06:
07: LIBFOO_VERSION = 1.0
08: LIBFOO_SOURCE = libfoo-$(LIBFOO_VERSION).tar.gz
09: LIBFOO_SITE = http://www.foosoftware.org/download
10: LIBFOO_LICENSE = GPL-3.0+
11: LIBFOO_LICENSE_FILES = COPYING
12: LIBFOO_INSTALL_STAGING = YES
13: LIBFOO_CONFIG_SCRIPTS = libfoo-config
14: LIBFOO_DEPENDENCIES = host-libaaa libbbb
15:
16: define LIBFOO_BUILD_CMDS
17:     $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
18: endef
19:
20: define LIBFOO_INSTALL_STAGING_CMDS
21:     $(INSTALL) -D -m 0755 $(@D)/libfoo.a $(STAGING_DIR)/usr/lib/libfoo.a
22:     $(INSTALL) -D -m 0644 $(@D)/foo.h $(STAGING_DIR)/usr/include/foo.h
23:     $(INSTALL) -D -m 0755 $(@D)/libfoo.so* $(STAGING_DIR)/usr/lib
24: endef
25:
26: define LIBFOO_INSTALL_TARGET_CMDS
27:     $(INSTALL) -D -m 0755 $(@D)/libfoo.so* $(TARGET_DIR)/usr/lib
28:     $(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/foo.d
29: endef
30:
31: define LIBFOO_USERS
32:     foo -1 libfoo -1 * - - - LibFoo daemon
33: endef
34:
35: define LIBFOO_DEVICES
36:     /dev/foo c 666 0 0 42 0 - - -
37: endef
38:
39: define LIBFOO_PERMISSIONS
40:     /bin/foo f 4755 foo libfoo - - - - -
41: endef
42:
43: $(eval $(generic-package))
```

<br>

## 5. Select package
Open the configuration menu `make menuconfig`, find `libfoo` and select the configuration.

<br>

## 6. Compile
```bash
# Compile libfoo
make libfoo
make
# If you modify the source code, recompile the package
make libfoo-rebuild
```

<br>

# Package infrastructures
Each software component to be built by Buildroot comes with its **own build system**.<br>

List of package infrastructures:
- `generic-package`, for software components with **non-standard** build systems;
- `autotools-package`, for `autotools` based packages, covered later;
- `python-package`, for `distutils` and setuptools based Python packages;
- ...

<br>

In a package using `generic-package`, only the **download**, **extract** and **patch** steps are implemented by the **package infrastructure**.
The other steps (**configuring**, **compiling**, **installing**) should be described by the package `<pkg>.mk` file.

<br>

# Target vs. host packages
Most of the packages in Buildroot are **target packages**, i.e., they are **to be run on the target platform**.<br>
Some packages are **host packages**, i.e., they are **to be executed on the build machine**. **Host packages** are needed for the build process of other packages.<br>
The majority of **host packages** are not visible in menuconfig: they are just dependencies of other packages, the user doesn’t really need to know about them.<br>
A few of them are potentially directly useful to the user (flashing tools, etc.), and can be shown in the `Host utilities section` of menuconfig.<br>
In this case, the **configuration option** is in a `Config.in.host` file, included from `package/Config.in.host`, and the option must be named `BR2_PACKAGE_HOST_<PACKAGE>`.<br>

<br>

## Example
```bash
package/Config.in.host
menu "Host utilities"
    source "package/genimage/Config.in.host"
    source "package/lpc3250loader/Config.in.host"
    source "package/openocd/Config.in.host"
    source "package/qemu/Config.in.host"
endmenu
```

<br>

```bash
package/openocd/Config.in.host
    config BR2_PACKAGE_HOST_OPENOCD bool "host openocd"
    help
        OpenOCD - Open On-Chip Debugger
        http://openocd.org
```

<br>

# Patches
## Patches order
The patches are applied in this order:
1. Patches mentioned in the `<pkg>_PATCH` variable of the package `.mk` file. They are automatically downloaded before being applied.
2. Patches present in the package directory `package/<pkg>/*.patch`.
3. Patches present in the **global patch directories**. These directories must contain sub-directories named as packages and containing the patches to be applied.

<br>

In each case, they are applied:
- in the order specified in a **series file**, if available;
- otherwise, in **alphabetic ordering**.

<br>

## Patch conventions
Names of patches should start with a **sequence number** that indicates the ordering in which they should be applied.<br>

```bash
ls package/nginx/*.patch
0001-auto-type-sizeof-rework-autotest-to-be-cross-compila.patch 0002-auto-feature-add-mechanism-allowing-to-force-feature.patch
```

<br>

# External tree mechanism
The `BR2_EXTERNAL` mechanism allows to store your own `package recipes`, `defconfigs` and `other artefacts` **outside** of the *Buildroot source tree*.<br>
It is possible to use **several** `BR2_EXTERNAL` trees.

<br>

## Using BR2_EXTERNAL
`BR2_EXTERNAL` is **not** a configuration option, only an environment variable to be passed on the command line:
```bash
make BR2_EXTERNAL=/path/to/external1:/path/to/external2
```

<br>

It is automatically saved in the hidden `.br2-external.mk` file in the output directory:
- no need to pass `BR2_EXTERNAL` at every make invocation;
- can be **changed** at any time by passing a **new value**;
- can be **removed** by passing an **empty value**;

<br>

Can be either an **absolute** or a **relative** path, but if relative, important to remember that it’s relative to the *Buildroot source directory*.

<br>

## BR2_EXTERNAL layout
Each **external directory** must contain:
- `external.desc`, which provides a **name** and **description**;
- `external.mk`, will be included in the **make logic**;
- `Config.in`, **configuration options** that will be included in `menuconfig`;

<br>

## BR2_EXTERNAL: recommended structure
```bash
board/
    <company>/
        <boardname>/
configs/
    <boardname>_defconfig
package/
Config.in
external.mk
external.desc
```

<br>

## `external.desc`
Buildroot uses the `external.desc` text file to identify and differentiate **multiple** **br2_external** directories.<br>
`external.desc` contains the description:
```bash
name: my_tree
desc: My simple external-tree for article
```

<br>

The `name` field will be used to define `BR2_EXTERNAL_<NAME>_PATH` available in `Config.in` and `.mk` files, pointing to the **external tree directory**.

<br>

## `external.mk`
`external.mk` can include custom make logic. Generally only used to include the package .mk files:
```bash
include $(sort $(wildcard $(BR2_EXTERNAL_<NAME>_PATH)/package/*/*.mk))
```

<br>

## Start building using external tree
To start compiling use 
`make BR2_EXTERNAL = ../my_tree/my_x86_board_defconfig`
