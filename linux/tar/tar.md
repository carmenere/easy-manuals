# Main options
|Option|Comment|
|:-----|:------|
|``-f``|File where to save result, if ommited, **tar** will output result to **stdout**.|
|``-c``|Create archive.|
|``-z``|Compress/decompress archive with **gzip**.|
|``-j``|Compress/decompress  archive with **bzip2**.|
|``-J``|Compress/decompress  archive with **xz**.|
|``--lzma``|Compress/decompress  archive with **lzma**.|
|``-x``|Extract files from an archive.|
|``-C ${DIR}``|The ``-C`` option defines:<br>• a directory ``${DIR}`` where it will extract files.<br>• a directory from which it takes files for archiving.|

<br>

# Examples
## Crate archive
```bash
tar -czvf arch.tar.gz ./test
a ./test
a ./test/file2.txt
a ./test/file1.txt
```

Takes files from **./test** and creates new archive **arch.tar.gz**.

<br>

## Extract files from an archive
```bash
tar -xzvf arch.tar.gz
x ./test/
x ./test/file2.txt
x ./test/file1.txt
```
