# time
Measures how long a **command**, **script** or **shell function** takes to run. Note, to measure **shell function** run it inside subshell, e.g. `time ( shell_func_name )`.<br>

There are 3 type of time:
- **Real time** (aka **wall clock time**, **wall time** ot **total time**) - time from **start** to **finish** of the call, it is gathered from the **gettimeofday** (2) call.This is **all elapsed time including time slices used by other processes** and **time the process spends blocked** (for example if it is **waiting for I/O** to complete).
- **User** is the amount of **CPU time spent in user-mode code** (outside the kernel) within the process. This is only **actual CPU time** used in executing the process. Other processes and time the process spends blocked do not count towards this figure.
- **Sys** is the amount of **CPU time spent in the kernel** within the process. This means executing **CPU time spent in system calls within the kernel**, as opposed to library code, which is still running in user-space. Like 'user', this is only CPU time used by the process. See below for a brief description of kernel mode (also known as 'supervisor' mode) and the system call mechanism.

<br>

So,
- **Real** represents **actual elapsed time**, while **user** and **sys** values represent **CPU execution time**.
- **User+Sys** will tell you how much **actual CPU time your process used**.<br>

<br>

Note that this is **across all CPUs**, so if the process has **multiple threads** (and this process is running on a computer with more than one processor) it could potentially exceed the **wall clock time** reported by **Real** (which usually occurs).<br>
In other words, on a **multicore** system, the **user** and/or **sys** time (as well as their sum) **can** actually **exceed** the **real** time.<br>

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
      - similar to `gettimeofday()` it represents the amount of time (in **seconds** and **nanoseconds**) since the **Epoch**;
      - it is **affected by NTP**, and can move **forwards** and **backwards**;
    - `CLOCK_MONOTONIC`:
      - **for precise measurement of elapsed time**;
      - is **not** affected by NTP;
      - it represents the absolute elapsed wall-clock time since some arbitrary, fixed point in the past;

<br>

## Hardware specific instructions
### `amd64`/`x86`
The **Time Stamp Counter** (**TSC**) is a **64-bit register** present on all `amd64`/`x86` CPUs processors.<br>
It counts the number of **CPU cycles** (ticks) since its reset.<br>

<br>

There are 2 instructions to read time:
- `RDTSC` **only** returns **TSC** value;
- `RDTSCP` returns **TSC** value and **processor ID**, it is better for multicore;

<br>

# Rust `Instant` crate
```rust
let now = Instant::now();
...
let elapsed = now.elapsed();
```

<br>

The `elapsed` corresponds the **real** time of cli command `time`.<br>
The `Instant` uses `clock_gettime` syscall with **clock source** `CLOCK_MONOTONIC`.<br>
