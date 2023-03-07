# `/dev/console`
The `/dev/console` file is a generic name given to the **system console**.<br>
The `/dev/console` is the device to which **kernel** sends messages.<br>
The `/dev/console` is opened in the kernel function `kernel_init_freeable()`.<br>
The `/dev/console` can be pointed to a variety of devices.

<br>

## 
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
- `/dev/tty0` is associated with a **current virtual terminal**, i.e., **current active console**;
- `/dev/tty0` = `/dev/console`;
