# Simplified Linux system architecture
1. Userspace:
- apps;
- libs;
2. Kernelspace:
- memory management;
- process/threads management;
- networking;
- filesystems;
- device drivers;
3. Botloader.
4. Hardware.

<br>

# Linux boot sequence
## 1. Bootloader
Bootloader loads **DTB** and **kernel** into RAM, starts the kernel.

<br>

### Bootstrap
In the general sense, **bootstrapping** is a process of setting up a **complex system** by a **simpler system**.<br>

A **bootstrap** is the first program a computer runs on power up. This is usually the **BIOS** or **UEFI**.<br>
The **bootstrap** then hands over control to the bootloader (e.g., the boot sector program on the boot drive (aka MBR)).<br>

<br>

## 2. Kernel
Kernel:
1. Initializes **hardware devices** and **kernel subsystems**.
2. Mounts **root filesystem** indicated by `root=` kernel arg.
3. Starts userspace application, `/sbin/init` by default.

<br>

## Init subsystem
**Init subsystem** starts other **userspace** *applications* and *daemons*.

<br>

# Embedded Linux work
▶ **BSP work**: porting the bootloader and Linux kernel, developing Linux device drivers.<br>
▶ **System integration work**: assembling all the user space components needed for the system, configure them, develop the upgrade and recovery mechanisms, etc.<br>
▶ **Application development**: write the company-specific applications and libraries.<br>

<br>

# BSP
**Board Support Package** (**BSP**) is the layer of software containing **bootloader** and **hardware-specific drivers** that allow a particular OS to function in a particular hardware environment.<br>
Third-party **hardware developers** who wish to support a particular OS must create a **BSP** that allows that OS to run on their platform.<br>
The most popular hardware architectures: `PowerPC`, `ARM`, `x86`, `MIPS`.

<br>

# DTS and DTB
A **Device Tree** is a **data structure** describing the **hardware components** of a **particular computer** so that the OS's kernel can use and manage those components, including the CPU or CPUs, the memory, the buses and the integrated peripherals.<br>
The **device tree** is specified in a `.dts` file (**Device Tree Source**) and is compiled into a `.dtb` file (**Device Tree Blob** or **Device Tree Blob Binary**) file through the **Device Tree Compiler** (**DTC**). `.dts` file must be written with **DTS syntax**.<br>
In other words, the `.dtb` is created from `.dts` files and the resulting `.dtb` file contains information about the **board** and its **hardware**.<br>
The `.dtb` is loaded in memory by the **bootloader** (often `uboot`) **before** the kernel is started.<br>

Systems which use *device trees* usually pass a static device tree (perhaps stored in EEPROM) to the OS, but can also generate a device tree in the early stages of booting.

<br>

## Why is it needed?
Most **embedded** platforms **do not provide** a way of discovering the hardware they have. You either **have to resort to guesswork** (which is not viable), or **hardcode** the information about the board and the peripherals into the Linux kernel.<br>

With the `.dtb`, the same kernel can run on **multiple devices**, if it is given the right `.dtb` at boot time.<br>

<br>

## ACPI
Some OS and some architectures don't use **device trees**.<br>
For example, PCs with the **x86** architecture generally do not use **device trees**, relying instead on various **auto configuration protocols** (e.g. **ACPI**) to discover hardware.<br>
**Advanced Configuration and Power Interface** (**ACPI**) is an open standard that operating systems can use 
- to **discover** hardware components;
- to perform **power management** (e.g. putting unused hardware components to sleep);
- for **auto configuration** (e.g. Plug and Play and hot swapping);
- for **status monitoring**.

<br>

# Embedded Linux building
## Principle
1. Configuration.
2. Toolchain.
3. Kernel image.
4. Bootloader image(s).
5. Root filesystem image.
6. Open source components.
7. In-house components.

<br>

## Tools
Adapting a general-purpose distribution by cleaning out unnecessary packages and turning it into firmware is a more time-consuming way than building a new distribution.<br>
There are a wide range of solutions to building an entire distribution: `Yocto/OpenEmbedded`, `PTXdist`, `Buildroot`, `OpenWRT`, and more.<br>
Today, two solutions are emerging as the most popular ones:
- `Yocto/OpenEmbedded`: builds a **complete** Linux **distribution** *with* binary packages.
- `Buildroot`: can build a **toolchain**, a **rootfs**, a **kernel**, a **bootloader**, *no* binary packages.
