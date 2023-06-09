# Buildroot
**Buildroot** is a framework for building embedded Linux distributions.<br>
**Buildroot** builds code for the **board** **architecture** it was configured for.<br>
The entire **Buildroot** is composed of a makefiles and a `Config.in` configuration file (`Kconfig`).<br>
**Buildroot** is used to compile a complete Linux system software (including *boot*, *kernel*, *rootfs*, and various *libraries* and *applications* in rootfs) for the **board** **architecture** it was configured for.<br>
Adapting a general-purpose distribution by cleaning out unnecessary packages and turning it into firmware is a more time-consuming way than building a new distribution.<br>

<br>

# Directory structure
```sh
buildroot/
├── arch                # Configuration files of CPU architecture
├── board               # Documents related to specific boards
├── boot                # Configuration files of Bootloaders
├── build
├── CHANGES             # Buildroot modification log
├── Config.in
├── Config.in.legacy
├── configs             # Buildroot configuration file of the specific board
├── COPYING
├── DEVELOPERS
├── dl                  # Downloaded programs, source code compressed packages, patches, etc.
├── docs                # Documentation
├── fs                  # Configuration files of various filesystems
├── linux               # Configuration files of Linux
├── Makefile
├── Makefile.legacy
├── output              # Compile output directory
├── package             # Configuration files of all packages
├── README              # Simple instructions for Buildroot
├── support             # Scripts and configuration files that provide functional support for Bulidroot
├── system              # Configuration files of making root filesystem
├── toolchain           # Configuration files of cross-compilation toolchain
└── utils               # Utilities
```

<br>

# Configuration
You can issue the **default configuration** process by running `make xxx_defconfig` and target `xxx_defconfig` is a file in the folder `arch/arm/configs/` and `xxx` is a **board** or **arch**.<br>
The `make xxx_defconfig` creates your initial `.config`, which you can now edit through `make menuconfig` and make your changes.<br>

<br>

# Compile
After configuring Buildroot, run `make` directly to compile the whole linux system using your settings.

<br>

## Compile the package
We can execute `make <package>` to compile a package **separately**.<br>
The compilation of the software package mainly includes the process of
- downloading;
- decompressing;
- patching;
- configuring;
- compiling;
- installing. 

<br>

### Download
Buildroot will automatically obtain the corresponding software packages from the Internet according to the configuration `package/<package>/<package>.mk`, including some third-party libraries, plug-ins, utilities, etc., and place them in the `dl/` directory.

<br>

### Unzip
The package will be decompressed in the `output/rockchip_rk3399/build/<package>-<version>` directory.

<br>

### Patch
Patches are placed in the `package/<package>/` directory, and Buildroot will apply the corresponding patches after decompressing the package. If you want to modify the source code, you can modify it by patching.

<br>

### Configure
<br>

### Compile
`make <package>`

<br>

### Install
After the compilation is completed, the required compilation files will be copied to the `output/rockchip_rk3399/target/` directory.

<br>

### Output directory
After the compilation is complete, a subdirectory will be generated in the compilation output directory `output/rockchip_rk3399` as follows:
- `build/` This directory contains all package source code.
- `host/` Tools required for host-side compilation include cross-compilation tools.
- `images/` Contains a **compressed** *root filesystem* image file.
- `staging/` Contains the **complete** *root filesystem*. Compared to `target/`, it has development files, header files, and the binary files are not **stripped**.
- `target/` Contains the **complete** *root filesystem*. Compared to `staging/`, it has **no** development files, **no** header files, and the binary files are **stripped**.

<br>

# Compile
`configs` **subfolder** contains `buildroot defconfig` which points to a `linux defconfig` located in `board` **subfolder**.<br>
`BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="board/freescale/mpc8315erdb/linux-3.12.config"`<br>

<br>

# Rebuild
## Rebuild the package
During the development process, if the source code of a certain package is modified, Buildroot will not recompile the package.

### Method one
`make <package>-rebuild`

<br>

### Method two
```bash
# Delete the compiled output directory of the package
rm -rf output/rockchip_rk3399/build/<package>-<version>

# Compile
make <package>
```

<br>


<br>

## Full rebuild
### Method one
Directly **delete** the output directory, and then **re-configure** and **compile**.
`rm -rf output/`

<br>

### Method two
Executing the following command will delete the compilation output and recompile.
`make clean all`

<br>

# Adding new package to Buildroot
## 1. Create a project directory
`mkdir buildroot/package/rockchip/libfoo/`

<br>

## 2. Create Config.in file in libfoo/
`Config.in` files contain entries for almost anything configurable in Buildroot.

<br>

An entry has the following pattern:
```bash
config BR2_PACKAGE_LIBFOO
        bool "libfoo"
```

<br>

## 3. Modify the upper level Config.in
Add a line at the end of `buildroot/package/rockchip/Config.in`:
```bash
source "package/rockchip/firefly_demo/Config.in"
```

<br>

## 4. Create libfoo.mk in libfoo/
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
# Package into the root filesystem
make
# If you modify the source code, recompile the package
make libfoo-rebuild
```

<br>

# Makefile layout
# Variables
The list of variables that can be set in a `.mk` file to give **metadata** information is (assuming the package name is `libfoo`):
- `LIBFOO_VERSION`, mandatory, must contain the version of the package.<br>
- `LIBFOO_SOURCE` may contain the name of the tarball of the package, which Buildroot will use to download the tarball from `LIBFOO_SITE`.If `HOST_LIBFOO_SOURCE` is not specified, it defaults to `LIBFOO_SOURCE`. If none are specified, then the value is assumed to be `libfoo-$(LIBFOO_VERSION).tar.gz`.<br>
- `LIBFOO_PATCH` may contain a space-separated list of patch file names, that Buildroot will download and apply to the package source code.<br>
- `LIBFOO_LICENSE` defines the license (or licenses) under which the package is released.<br>
- `LIBFOO_LICENSE_FILES` is a space-separated list of files in the package tarball that contain the license(s) under which the package is released.<br>
- `LIBFOO_SITE` provides the location of the package, which can be a **URL** or a **local filesystem path**.<br>
- `LIBFOO_SITE_METHOD` determines the method used to fetch or copy the package source code. In many cases, Buildroot guesses the method from the contents of `LIBFOO_SITE` and setting `LIBFOO_SITE_METHOD` is unnecessary.<br>

<br>

All variables must start with the same prefix, `LIBFOO_` in this case. This prefix is always the **uppercased** version of the **package name**.<br>
`LIBFOO_INSTALL_STAGING=YES` means that this package wants to install something to the **staging space**.<br>
This is often needed for libraries, since they must install header files and other development files in the staging space.<br>
This will ensure that the commands listed in the `LIBFOO_INSTALL_STAGING_CMDS` variable will be executed.<br>

<br>

Following vars define what should be done at the different steps of the package **configuration**, **compilation** and **installation**:
- `LIBFOO_BUILD_CMDS` tells what steps should be performed to **build the package**;
- `LIBFOO_INSTALL_STAGING` can be set to **YES** or **NO** (default). If set to YES, then the commands in the `LIBFOO_INSTALL_STAGING_CMDS` variables are executed to install the package into the **staging directory**;
- `LIBFOO_INSTALL_TARGET` can be set to **YES** (default) or **NO**. If set to YES, then the commands in the `LIBFOO_INSTALL_TARGET_CMDS` variables are executed to install the package into the **target directory**;
- `LIBFOO_INSTALL_IMAGES` can be set to **YES** or **NO** (default). If set to YES, then the commands in the `LIBFOO_INSTALL_IMAGES_CMDS` variable are executed to install the package into the **images directory**;
- `LIBFOO_EXTRACT_CMDS` lists the actions to be performed to **extract** the package. This is needed if the package uses a non-standard archive format.
- `LIBFOO_CONFIGURE_CMDS` lists the actions to be performed to **configure** the package before its compilation.
- `LIBFOO_BUILD_CMDS` lists the actions to be performed to **compile** the package.
- `HOST_LIBFOO_INSTALL_CMDS` lists the actions to be performed to **install** the package, when the package is a **host package**.
- `LIBFOO_INSTALL_TARGET_CMDS` lists the actions to be performed to install the package to the **target** directory, when the package is a **target package**. 
- `LIBFOO_INSTALL_STAGING_CMDS` lists the actions to be performed to install the package to the **staging** directory, when the package is a **target package**.
- `LIBFOO_INSTALL_IMAGES_CMDS` lists the actions to be performed to install the package to the **images** directory, when the package is a **target package**.

<br>

The preferred way to define these variables is:
```bash
define LIBFOO_CONFIGURE_CMDS
        action 1
        action 2
        action 3
endef
```
<br>

All these steps rely on the `$(@D)` variable, which contains the **directory** where the **source code** of the **package** has been **extracted**.<br>

At the end of package makefile we call **generic-package macro**: `$(eval $(generic-package))`, which generates, according to the variables defined previously, all the Makefile code necessary to make your package working.<br>

During the development process, the built-in packages of Buildroot may not meet our needs sometimes, so we need to add a **custom package**.<br>
Buildroot supports packages in a variety of formats, including `generic-package`, `cmake-package`, `autotools-package`, etc. We take `generic-package` as an example.<br>

<br>

# Root fs overlay
A **filesystem overlay** is a tree of files that overwrites the specified files in **target filesystem** after the **target filesystem** is **compiled**.<br>
This mechanism makes it easy to add/replace files in the target file system.<br>
To enable **filesystem overlay**, set config option `BR2_ROOTFS_OVERLAY` (in the configuration menu `make menuconfig`) to the **root of the overlay**.<br>

<br>

## Example
Suppose, `BR2_ROOTFS_OVERLAY=board/rockchip/rk3399/fs-overlay/`.<br>

Add files to the `BR2_ROOTFS_OVERLAY` directory:<br>
```bash
cd buildroot/board/rockchip/rk3399/fs-overlay/
mkdir etc/
touch etc/test
```

<br>

Compile
```sh
make
```

<br>

# External tree mechanism
There is a **external tree mechanism**. Its essence is that you can store `board`, `configs`, `packages`, and **other directories** in a separate directory and buildroot will add them.

<br>

## Layout of a br2-external tree
A **br2-external tree** must contain at least those **three** files, described in the following chapters:
- `external.desc`;
- `external.mk`;
- `Config.in`

<br>

Buildroot uses the `external.desc` text file to identify and differentiate **multiple** **br2_external** directories.<br>
`external.desc` contains the description:
```bash
name: my_tree
desc: My simple external-tree for article
```

<br>

Buildroot sets the variable `BR2_EXTERNAL_$(NAME)_PATH` to the absolute path of the br2-external tree, so that you can use it to refer to your br2-external tree.<br>
This variable is available both in Kconfig, so you can use it to source your Kconfig files (see below) and in the Makefile, so that you can use it to include other Makefiles (see below) or refer to other files (like data files) from your br2-external tree.

<br>

`Config.in` and `external.mk` are for the description of added packages. If you do not add your packages, then these files can be left empty.<br>

<br>

# Start building using
To start compiling using 
`make BR2_EXTERNAL = ../my_tree/my_x86_board_defconfig`

Argument `BR2_EXTERNAL = ../my_tree/` invocates an external tree. It is possible to specify **several external-trees** for use **at the same time**.

`make BR2_EXTERNAL = ../my_tree/my_x86_board_defconfig` will create `output/.br-external.mk` file that stores information about the external-tree used.<br>
Then the external options item appeared in the menu: