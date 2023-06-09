# KConfig
**KConfig** is just a language. You have to use the **interpreter to show the menu**.<br>
In the Linux kernel, the interpreter is built when you run the `make *config` command.
Every directory in the kernel has one Kconfig that includes the Kconfig files of its subdirectories.
On top of the kernel source code directory, there is a Kconfig file that is the root of the options tree.
The menuconfig (scripts/kconfig/mconf), gconfig (scripts/kconfig/gconf) and other compile targets invoke programs that start at this root Kconfig and recursively read the Kconfig files located in each subdirectory to build their menus.
Which subdirectory to visit also is defined in each Kconfig file and also depends on the config symbol values chosen by the user.

<br>

## Tools
|Command|Description|
|:------|:----------|
|`make config`|**Question-and-answer-based** configuration tool. The options are prompted one after another. All options need to be answered, and out-of-order access to former options is not possible.|
|`make menuconfig`|Graphical menu using **ncurses**. Navigate through the menu to modify the arbitrary options.|
|`make xconfig`|Graphical menu using **Qt5**. Requires `dev-qt/qtwidgets` to be installed.|
|`make gconfig`|Graphical menu using **GTK**. Requires `x11-libs/gtk+`, `dev-libs/glib`, and `gnome-base/libglade` to be installed.|
|`make defconfig`|Generates a **new config** with *defaults* from the supplied **defconfig file** of appropriate `arch` that came with the sources.|
|`make allmodconfig`|Enables all modules in kernel.|

<br>

Configuration symbols are defined in files known as `Kconfig` files.
Each Kconfig file can describe an arbitrary number of symbols and can also include (source) other Kconfig files.
Compilation targets that construct configuration menus of kernel compile options, such as make menuconfig, read these files to build the tree-like structure.


<br>

## .config
The `.config` file is not simply copied from your `defconfig` file.<br>
In `defconfig` we can specify only options with **non-default values** (i.e. options we changed for our **board**/**arch**).<br>
This way we can keep it small and clear.

<br>

The build system generates two files, and keeps them consistent:
- `include/generated/autoconf.h` this header file is included by C source files;
- `.config` is for the **Makefile** system.

<br>

When `.config` file is being generated, *kernel build system* goes through all `Kconfig` files (from all subdirs), checking all options in those `Kconfig` files:
- if option is mentioned in `defconfig`, build system puts that option into `.config` with value chosen in `defconfig`;
- if option **isn't** mentioned in `defconfig`, build system puts that option into `.config` using its default value, specified in corresponding `Kconfig` file.
