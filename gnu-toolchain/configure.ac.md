# --prefix
When you run `./configure`, the `--prefix` option lets you specify where to place files. It is called `--prefix` because it lets you give the **prefix** that appears in the paths to each file.<br>
By default, **configure** sets the `prefix` for files it installs to `/usr/local`, so `./configure` is equivalent to `./configure --prefix=/usr/local`.<br>
The `--prefix=PREFIX` option installs all files in `PREFIX`.<br>
When you run a `make install` command, **libraries** will be placed in the `PREFIX/lib` directory, **executables** in the `PREFIX/bin` directory and so on.
