The /dev/console file is a generic name given to the system console.

/dev/console is the device to which kernel will send messages. 
/dev/console is opened in the kernel function kernel_init_freeable().
/dev/console is known as the system console.
/dev/console points to tty0.
/dev/console can be pointed to a variety of devices.

/dev/tty in each process, a synonym for the controlling terminal associated with the process group of that process, if any.

We can see that tty0 is the current active console.
/dev/tty is an alias to the terminal of the active process, regardless of the type of terminal. For instance, this can be the terminal associated with bash or sshd.
According to the POSIX standard, /dev/tty is considered to be the terminal associated with a process group whereas /dev/tty0 is associated with a virtual terminal.



The Linux kernel is configured to select the console by passing it the console parameter.
The console parameter can be given repeatedly, but the parameter can only be given once for each console technology.
So console=tty0 console=lp0 console=ttyS0 is acceptable but console=ttyS0 console=ttyS1 will not work.

When multiple consoles are listed output is sent to all consoles and input is taken from the last listed console.
The last console is the one Linux uses as the /dev/console device.

Figure 5-1. Kernel console syntax, in EBNF

console=ttyS<serial_port>[,<mode>]
console=tty<virtual_terminal>
console=lp<parallel_port>
console=ttyUSB[<usb_port>[,<mode>]
