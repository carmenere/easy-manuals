# Main options
|Option|Comment|
|:-----|:------|
|``-f ${FILE}``|File ``${FILE}`` where to save result, if ommited, **tar** will output result to **stdout**.|
|``-z``|Compress/decompress archive with **gzip**.|
|``-j``|Compress/decompress  archive with **bzip2**.|
|``-J``|Compress/decompress  archive with **xz**.|
|``--lzma``|Compress/decompress  archive with **lzma**.|
|``-c``|Create archive.|
|``-x``|Extract files from an archive.|

<br>

# Examples
## Crate archive
```bash
tar -czvf arch.tar.gz ./test
```

<br>

Output:
```bash
a ./test
a ./test/file2.txt
a ./test/file1.txt
```

Takes files from **./test** and creates new archive **arch.tar.gz**.

<br>

## Extract files from an archive
```bash
tar -xzvf arch.tar.gz
```

<br>

Output:
```bash
x ./test/
x ./test/file2.txt
x ./test/file1.txt
```
