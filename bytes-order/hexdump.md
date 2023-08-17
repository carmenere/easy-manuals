# hexdump
`hexdump` displays content of file in **binary** foramt.<br>
It uses **little-endian**.

<br>

## Options
- `-C` means **per byte hex+ASCII** display, like `od --endian=little -tx1`;

<br>

## Examples
```bash
$ hexdump abcd.txt 
0000000 4241 4443                              
0000004
```

<br>

```bash
$ hexdump -C abcd.txt
00000000  41 42 43 44                                       |ABCD|
00000004
```
