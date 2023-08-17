# od
`od` displays content of file in binary foramt.<br>

<br>

## Options
- `--endian=<val>` where `<val>` can be:
  - `big`;
  - `little` (by **default**);
- `-t <format><size>` where
  - `<format>` can be:
    - `x` means **hexadecimal**;
    - `u` means **unsigned decimal**;
    - `d` means **signed decimal**;
    - `o` means **octal**;
  - `size` can be:
    - `1` (**1 byte**);
    - `2` (**word** or 2 bytes);
    - `4` (**double word** or 4 bytes);

<br>

Without options `od` is equal to `od –to2`.<br>

<br>

## Examples
```bash
$ echo -ne "ABCD" > abcd.txt

$ cat abcd.txt
ABCD$ 
```

<br>

```bash
$ od --endian=little -tx4 abcd.txt
0000000 44434241
0000004

$ od --endian=big -tx4 abcd.txt
0000000 41424344
0000004
```

<br>

```bash
$ od --endian=little -tx2 abcd.txt
0000000 4241 4443
0000004

$ od --endian=big -tx2 abcd.txt
0000000 4142 4344
0000004
```

<br>

```bash
$ od --endian=little -tx1 abcd.txt
0000000 41 42 43 44
0000004

$ od --endian=big -tx1 abcd.txt
0000000 41 42 43 44
0000004
```
