# Site-packages
There are 2 types of **site-packages** directories: 
- **global site-packages** directories are for **globally** installed *third-party* packages;
- **user site-packages** directory is for **locally** installed *third-party* packages;

<br>

When a *third-part*y package is installed **globally**, it’s made **available** to **all users** that log into the system.<br>
Conversely, when a *third-party* package is installed **locally**, it’s **only** made **available** to **the user that installed** it.<br>

<br>

> **Note**:<br>
> **dist-packages** is the **debian-specific global site-packages** directory where `apt` installs *third-party* packages.<br>
> **site-packages** is the **standard** directory where `pip` installs *third-party* packages.

<br>

With **Python 3.11** **pip will refuse to install packages alongside the system's**.<br>
There is `--break-system-packages` cli option or `PIP_BREAK_SYSTEM_PACKAGES=1` environment variable to tell pip it's OK to **break** your system packages.

<br>

```bash
.venv/bin/python -m pip install --user -r requirements.txt
ERROR: Can not perform a '--user' install. **User site-packages are not visible in this virtualenv**.
```

<br>

- `python3 -m pip list` shows list of **globally** installed *third-party* packages;
- `python3 -m pip list --user` shows list of **locally** installed *third-party* packages;

<br>

# site.py
The `site.py` module is automatically imported on initialization. It controls `sys.path`.<br>

**Python** cli options that influence on `site.py`:
`-S` don't imply `import site` on initialization;
`-s` don't add **user site-packages** directory to `sys.path`, also `PYTHONNOUSERSITE`;

<br>

#### Linux
```bash
anton@zinfandel:~$ python3
Python 3.11.4 (main, Jun  9 2023, 07:59:55) [GCC 12.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import site
>>> site.PREFIXES
['/usr', '/usr']
>>>
```

<br>

#### MacOS
```bash
Python 3.11.4 (main, Jul 25 2023, 17:36:13) [Clang 14.0.3 (clang-1403.0.22.14.1)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import site
>>> site.PREFIXES
['/opt/homebrew/opt/python@3.11/Frameworks/Python.framework/Versions/3.11', '/opt/homebrew/opt/python@3.11/Frameworks/Python.framework/Versions/3.11']
>>>
```

<br>

## site.py methods
`site.getsitepackages()`
Return a list containing **all global site-packages directories**.

<br>

`site.getuserbase()`
Return the path of the **user base directory**, `USER_BASE`.<br>
If it is not initialized yet, this function will also set it, respecting `PYTHONUSERBASE`.

<br>

`site.getusersitepackages()`
Return the path of the **user-specific site-packages directory**, `USER_SITE`.<br>
If it is not initialized yet, this function will also set it, respecting `USER_BASE`.

<br>

#### Linux
```bash
anton@zinfandel:~$ python3 -c "import site; print(site.getsitepackages()); print(site.getuserbase()); print(site.getusersitepackages())"
['/usr/local/lib/python3.11/dist-packages', '/usr/lib/python3/dist-packages', '/usr/lib/python3.11/dist-packages']
/home/anton/.local
/home/anton/.local/lib/python3.11/site-packages
```

<br>

#### MacOS
```bash
an.romanov@NB0737 Projects/ololo/dev-tools [DT-5] % python3 -c "import site; print(site.getsitepackages()); print(site.getuserbase()); print(site.getusersitepackages())"
['/opt/homebrew/opt/python@3.11/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages']
/Users/an.romanov/Library/Python/3.11
/Users/an.romanov/Library/Python/3.11/lib/python/site-packages
```

<br>

## site.py vars
#### `site.PREFIXES`
A list of prefixes for **site-packages directories**.

<br>

#### `site.USER_SITE`
Path to the **user site-packages** for the running Python.
Default value is 
- `~/.local/lib/pythonX.Y/site-packages` for UNIX and non-framework macOS builds
- `~/Library/Python/X.Y/lib/python/site-packages` for macOS framework builds.

<br>

#### `site.ENABLE_USER_SITE`
Flag showing the status of the **user site-packages directory**:
- `True` means that it is enabled and was added to `sys.path`;
- `False` means that it was disabled by user request (with `-s` or `PYTHONNOUSERSITE`). 

<br>

#### `site.USER_BASE`
Path to the **base directory** for the **user site-packages**.<br>
Default value is
- `~/.local` for **UNIX** and **macOS** non-framework builds;
- `~/Library/Python/X.Y` for macOS framework builds.
See also `PYTHONUSERBASE`.

<br>

# site.py cli options
If `site.py` is called **without arguments**, it will print the contents of `sys.path` on the standard output, followed by the value of `USER_BASE` and its state (exists or not), then the same thing for `USER_SITE`, and finally the value of `ENABLE_USER_SITE`.

<br>

```bash
anton@zinfandel:~$ python3 -m site
sys.path = [
    '/home/anton',
    '/usr/lib/python311.zip',
    '/usr/lib/python3.11',
    '/usr/lib/python3.11/lib-dynload',
    '/usr/local/lib/python3.11/dist-packages',
    '/usr/lib/python3/dist-packages',
]
USER_BASE: '/home/anton/.local' (doesn't exist)
USER_SITE: '/home/anton/.local/lib/python3.11/site-packages' (doesn't exist)
ENABLE_USER_SITE: True
```

<br>

The `site.py` module also provides following command line options:
```bash
--user-base
Print the path to the user base directory.

--user-site
Print the path to the user site-packages directory.
```

<br>

Example:
```bash
python3 -m site --user-site
/home/user/.local/lib/python3.3/site-packages
```
