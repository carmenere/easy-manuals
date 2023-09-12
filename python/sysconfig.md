# sysconfig
The options with which the Python interpreter was compiled are found in the `CONFIG_ARGS` variable of the `sysconfig` module.

<br>

#### Linux
```bash
Python 3.11.4 (main, Jun  9 2023, 07:59:55) [GCC 12.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import sysconfig
>>> sysconfig.get_config_var('CONFIG_ARGS')
"'--enable-shared' '--prefix=/usr' '--libdir=/usr/lib/aarch64-linux-gnu' '--enable-ipv6' '--enable-loadable-sqlite-extensions' '--with-dbmliborder=bdb:gdbm' '--with-computed-gotos' '--without-ensurepip' '--with-system-expat' '--with-dtrace' '--with-wheel-pkg-dir=/usr/share/python-wheels/' '--with-ssl-default-suites=openssl' 'MKDIR_P=/bin/mkdir -p' '--with-system-ffi' 'CC=aarch64-linux-gnu-gcc' 'CFLAGS=-g     -fstack-protector-strong -Wformat -Werror=format-security  ' 'LDFLAGS=-Wl,-Bsymbolic-functions     -g -fwrapv -O2   ' 'CPPFLAGS=-Wdate-time -D_FORTIFY_SOURCE=2'"
>>>
```

<br>

#### MacOS
```bash
Python 3.11.4 (main, Jul 25 2023, 17:36:13) [Clang 14.0.3 (clang-1403.0.22.14.1)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import sysconfig
>>> sysconfig.get_config_var('CONFIG_ARGS')
"'--prefix=/opt/homebrew/opt/python@3.11' '--enable-ipv6' '--datarootdir=/opt/homebrew/opt/python@3.11/share' '--datadir=/opt/homebrew/opt/python@3.11/share' '--without-ensurepip' '--enable-loadable-sqlite-extensions' '--with-openssl=/opt/homebrew/opt/openssl@3' '--enable-optimizations' '--with-system-expat' '--with-system-libmpdec' '--with-readline=editline' '--with-lto' '--enable-framework=/opt/homebrew/opt/python@3.11/Frameworks' '--with-dtrace' '--with-dbmliborder=ndbm' 'MACOSX_DEPLOYMENT_TARGET=13' 'CFLAGS=-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk' 'CFLAGS_NODIST=-I/opt/homebrew/include' 'LDFLAGS=-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk' 'LDFLAGS_NODIST=-L/opt/homebrew/lib -Wl,-rpath,/opt/homebrew/lib' 'CPPFLAGS=-I/opt/homebrew/include' 'py_cv_module__tkinter=disabled' 'PKG_CONFIG_PATH=/opt/homebrew/opt/openssl@3/lib/pkgconfig:/opt/homebrew/opt/readline/lib/pkgconfig:/opt/homebrew/opt/sqlite/lib/pkgconfig:/opt/homebrew/opt/xz/lib/pkgconfig' 'PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig:/opt/homebrew/Library/Homebrew/os/mac/pkgconfig/13' 'CC=clang'"
>>>
```