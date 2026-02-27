# time
## Linux `time` cli util
The `time` cli util measures how long a **command**, **script** or **shell function** takes to run. Note, to measure **shell function** run it inside subshell, e.g. `time ( shell_func_name )`.<br>

There are **3 type of time**:
- **real time** (aka **elapsed time**, **wall-clock time**, **wall time** ot **total time**) - time from **start** to **finish** of the call, it is gathered by the `gettimeofday()` or `clock_gettime()` syscalls. It **also counts** time while a process is **suspended**/**blocked**, for example while it is **waiting for I/O**.
- **user time** is the **actual CPU execution time** a process **spent in userspace**. It **does not count** time while a process is **suspended**/**blocked**.
- **sys time** is the **actual CPU execution time** a process **spent in the kernelspace**, i.e. **during systemcalls**. It **does not count** time while a process is **suspended**/**blocked**.

<br>

So,
- **real** tells you **actual elapsed time**;
- **user** and **sys** tells you **actual CPU execution time**;

<br>

**Note** that **user+sys** are counted **per a thread**. If a process has **multiple threads** on a **multicore** system, the **user** and/or **sys** time **can exceed** the **real** time.<br>

<br>

## Syscalls
The **Epoch** is a moment of time `January 1, 1970, 00:00:00 UTC`.<br>

<br>

**Syscalls** to get time:
- `gettimeofday()`:
  - resolution: **microseconds**;
  - represents the amount of time (in **seconds** and **microseconds**) since the **Epoch**;
  - **POSIX.1-2008** marks `gettimeofday()` as **obsolete**, recommending the use of `clock_gettime()` instead;
- `clock_gettime()`:
  - resolution: **nanoseconds**, depending on the **clock source**;
  - supports several **clock sources**:
    - `CLOCK_REALTIME`:
      - similar to `gettimeofday()` it represents the **seconds** and **nanoseconds** since the **Epoch**;
      - for this clock **both** `clock_gettime()` and `clock_settime()` are available;
      - so, `CLOCK_REALTIME` **can** be changed by *NTP* or *system administrator*, and **can move forwards** and **backwards**;
    - `CLOCK_MONOTONIC`:
      - it represents the **wall-clock** time in **seconds** and **nanoseconds** since an **unspecified point in the past** (for example, in linux it is **system start-up time**);
      - for this clock **only** `clock_gettime()` is available;
      - so `CLOCK_MONOTONIC` **cannot** be changed via `clock_settime()`, in other words, `CLOCK_MONOTONIC` **is not changed after system start-up time**;

<br>

## Hardware specific instructions
The **Time Stamp Counter** (**TSC**) is a **64-bit register** present on all `amd64`/`x86` CPUs processors.<br>
It counts the number of **CPU cycles** (ticks) since its reset.<br>

<br>

There are 2 instructions to read time:
- `RDTSC` **only** returns **TSC** value;
- `RDTSCP` returns **TSC** value and **processor ID**, it is better for multicore;
