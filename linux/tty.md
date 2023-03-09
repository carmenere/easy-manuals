# `/dev/console`
The `/dev/console` file is a generic name given to the **system console**.<br>
The `/dev/console` is the device to which **kernel** sends messages.<br>
The `/dev/console` is opened in the kernel function `kernel_init_freeable()`.<br>
The `/dev/console` can be pointed to a variety of devices.

<br>

The main structs are `struct consw` and `struct console`.

<br>

## Kernel `console` parameter
The Linux kernel is configured to select the console by passing it the `console` parameter.<br>
The `console` parameter can be given **repeatedly**, but the parameter can only be given **once** for **each** *console technology*.<br>
So `console=tty0 console=lp0 console=ttyS0` is **acceptable** but `console=ttyS0 console=ttyS1` will **not** work.<br>

When multiple consoles are listed **output** is sent to **all** consoles and **input** is taken from the **last** listed `console`.<br>
The **last** `console` is the one Linux uses as the `/dev/console` device.

<br>

#### Example: linux kernel's parameter `console`
```bash
console=ttyS<serial_port>[,<mode>]
console=tty<virtual_terminal>
console=lp<parallel_port>
console=ttyUSB[<usb_port>[,<mode>]
```

<br>

# `/dev/tty` and `/dev/tty0`
According to the **POSIX standard**:
- `/dev/tty` is considered to be the **controlling terminal** associated with a **process group**;
- `/dev/tty0` is associated with a **current VT**, i.e., **current VC**;

<br>

# TTY Device (aka Linux TTY Subsystem)
**Console** is a **physical terminal** (like *VT100*) connected to a computer via **serial** or **USB** port or **KB** + **Monitor**.

**TTY Device** consists of 3 layers:
- **TTY Driver** (*Hardware Driver*): UART (serial port driver), USB
- **TTY Line Discipline**
- **TTY Core** (*TTY General Driver*)

The user-space apps communicate with **TTY Core** via **syscalls** and **signals**.

<br>

## TTY device types
|TTY device type|Description|
|**Serial** |**Physical device** that is connected to PC by **serial** interface or **USB**.|
|**Console**|Kernel API to emulates **multiple terminals** *over* the **same console** (**physical terminal** or **KB** + **Monitor**). This kernel API is known as **Virtual Terminal** (**VT**) or **Virtual Console** (**VC**).|
|**PTY (PseudoTerminal)**|Kernel API for **terminal emulators** apps for GUI.|

<br>

> **Note**: <br>
> **VT** is run in the **kernel-space** and controll all *input* and *output* **inside kernel**.<br>
> **Terminal emulator** is run in the **user-space** and controll all *input* and *output* **inside user-space**. Any terminal app you launch from a GUI uses **PTY**.<br>
> **Monitor** and **KB** are no longer part of **VT**, they are now **separate devices**.<br>
> Linux kernel privides up to **63** *VT*. Most distributions initialize only **7** VTs.<br>
> *VT1* - *VT6* are in **text mode**, *VT7* is for **graphical mode**. **X-Server** is started on at least one *VT* (usually `/dev/tty7`). This is **X-Session #0**.<br>
> Switch between *VTs*: `Alt + FN` or `Ctrl + Alt + FN` (`FN`: *F1*, *F2*, ...).<br>

<br>

## TTY Core
**TTY Core** provides API for user-space apps to TTY Device throgh character devices `/dev/tty*`:
|Character device|Major and minor numbers|Name|
|`/dev/tty`|(5,0)|**Controlling Terminal**|
|`/dev/console`|(5,1)|**Console Terminal**|
|`/dev/tty0`|(4,0)|**VT**|
|`/dev/ttyN`|(4,1)|**VT**|
|`/dev/ttyS0`|(x,x)|**Serial Terminal**|
|`/dev/ttyUSB0`|(x,x)|**USB to Serial Terminal**|
|`/dev/ptmx` and `/dev/pts/<pty_number>`|**PTY**|

<br>

```
Monitor + Keyboard + Mouse
                           \
        (hardware drivers: UART, USB, KB, Video card) 
                              \
                fbcon(framebuffer console driver)
                               \
                                 <-> /dev/console <-> TTY Device <-> Apps
                               /
                       printk()
```

The tty hardware driver converts the data into a format that can be sent to the hardware.

<br>

*Text mode*:
 - kernel: forward keyboard keystrokes to **active VT**;
 - kernel: video card driver redraws screen of **active VT**;
 - kernel forward `printk()` messages to `/dev/console` which forwards its buffer according its settings (`console` parameter);

<br>

*GUI mode*:
 - kernel: forward keyboard keystrokes to **active window**, e.g., **terminal emulator**;
 - kernel: video card driver redraws screen;

<br>

**TTY Core** abstracts underlies levels with `struct tty_struct` and contains pointers to:
- `struct tty_ldisc` (field `ldisc`) provides access to **TTY Line Discipline**;
- `struct tty_driver` (field `driver`) provides access to **TTY Driver** (*Hardware Driver*).

<br>

Apps interct with *TTY Device* through **standard syscalls**.<br>

Syscall `open(/dev/tty*)` returns `fd` of **TTY Device** and is represented by `struct file`:
```C
struct file {
    f_ops -> struct file_operations {
        private_date -> struct tty_struct {
            ...
        }
    }
}
```

<br>

Field `f_ops` stores pointers to `file_operations` and `private_data`:
- `file_operations` stores callbacks to oedinary file operations: `open`, `close`, `read`, `write`, `ioctl`, ... ;  
- `private_data` stores pointer to `struct struct_tty`.

Main fields of `struct tty_struct`:
- `tty_ldisc` (poiner to TTY Line Discipline);
- `tty_driver` (pointer to TTY Driver); 
- `tty_operations` (direct pointers to TTY Driver's operations).


<br>

**TTY Core** is **controlling terminal** and facilitates **job control**, it
- tracks **foreground job**;
- delivers bytes to **active process**;
- sends `SIGTTIN` and `SIGTTOU`;

<br>

## TTY Line Discipline
**TTY Line Discipline** intercepts **control characters** and **escape sequences**, e.g., **erase** word, **backspace**, **clear** line, **echo**, ... .<br>

**TTY Line Discipline** has 2 modes:
1. The **raw mode** or **noncanonical mode**: line discipline just passes each character as is.
2. The **cooked mode** or **canonical mode** (by default): line discipline intercepts **control characters** and **escape sequences** and react on them.

<br>

Many applications (like Vim for example) use the **noncanonical mode**  to get all the characters you type directly.<br>

### `stty`
There is tool to set TTY Line Discipline: `stty`.
`stty -a` list currunt settings of TTY Line Discipline of controlling terminal.

<br>

### shell **control characters** and **escape sequences**
Some **control characters** and **escape sequences** may not be mapped in your terminal.<br>
In **bash**, the *default* **key bindings** correspond to the **Emacs** editor.<br>
In **bash** there is a builtin command `bind` to change how **bash** responds to **keys**, i.e., set **key bindings** to some functions.<br>

To see current **key bindings** run `bind -P`.<br>

<br>

## TTY Driver
Every **TTY Driver** needs to create a `struct tty_driver` that describes itself and registers that structure in TTY Core (`struct tty_struct`).<br>
Actually, creating `struct tty_driver` means creating **TTY Driver**.<br>
To instantiate **TTY Driver** there is `alloc_tty_driver()` function.<br>

<br

# PTY
**PTY (PseudoTerminal)** is a kernel API for **terminal emulators** apps for GUI.<br>
**Terminal emulator** is run in the **user-space** and controll all *input* and *output* **inside user-space**. Any terminal app you launch from a GUI uses **PTY**.<br>

<br>

**PTY** consists of **2** *TTY Devices* that are **connected** to each other *inside the kernel*:
- **PTM** (PTY **master**), it is just **file descriptor** that is connected to **PTS** inside kernel;
- **PTS** (PTY **slave**), it is a **character device file** `/dev/pts/<pty_number>`;

<br>

**PTY** is represented by `/dev/ptmx` file: 
1. **Terminal emulator** opens **PTY** by opening the file `/dev/ptmx` and save returned `pty_number`.
2. Then it creates child process via `fork()`.
3. Then child becomes **session leader**, opens **PTS** (`/dev/pts/<pty_number>`), connects **STDIN**, **STDOUT** and **STDERR** to **PTS**.
4. Call `exec()` and replace itself with **shell**.

<br>

> **Note**: <br>
> **PTS** gets *intput* from **PTM**, **not** from keyboard.<br>
> **PTS** sends its *output* to **PTM**, **not** to video card.<br>
> **PTM** gets *intput* from **terminal emulator**, **not** from keyboard.<br>
> **PTM** sends its *output* to **terminal emulator**, **not** to video card.<br>
> **Terminal emulator** gets *intput* from from keyboard.<br>
> **Terminal emulator** sends its *output* to video card.<br>

<br>

# Data traversing throgh TTY Devices
## Stages of passing data from keyboard to TTY:
1. The keyboard controller sends a **scan-code** to the port controller for every key press and release.
2. The port controller, having placed the **scan-code** at the address of its input port, generates an **interrupt**, which is processed by the **KB Driver**.
3. The **KB Driver** reads the **scan-code** from the input port and converts it into a keycode and passes it to the input core, which passes it to the Keyboard Event Handler.
4. **Keyboard Event Handler**, based on the **keymap** loaded into memory, determines whether any handler is associated with the given key code (**keycode handler**): if no handler is associated with the keycode, then it is converted to **char-code** based on the encoding table and transferred to the current **VT**, if any handler is associated with keycode, then this handler is called (for example, the following actions can be associated with kecode: switching the virtual terminal, reloading, etc.).

<br>

## Order of callbacks to **echo** of character inside **PTY**:
```C
__vfs_write() -> // VFS
    tty_write() -> // TTY Core
        do_tty_write() -> // TTY Core
            n_tty_write() -> // TTY Line Discipline
                pty_write() // to PTY driver
```

<br>

## Order of callbacks to **echo** of character inside **VT**:
```C
__vfs_write() -> // VFS
    tty_write() -> // TTY Core
        do_tty_write() ->
            n_tty_write() -> // TTY Line Discipline
                con_write() -> // TTY Driver
                    do_con_write() -> // to video card driver
```