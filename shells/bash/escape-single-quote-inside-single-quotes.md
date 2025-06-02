<!-- TOC -->
* [Escaping quotes in bash](#escaping-quotes-in-bash)
  * [Using ``'"'"'`` to escape `'`](#using--to-escape-)
  * [ANSI C quoting](#ansi-c-quoting)
    * [Examples](#examples)
      * [Broken code](#broken-code)
      * [Working code](#working-code)
<!-- TOC -->

<br>

# Escaping quotes in bash
## Using ``'"'"'`` to escape `'`
Assume that you need to execute such a command:
```bash
sh -c 'sed -E -n -e 's/^([a-zA-Z0-9_-]+)/"\1"/p' example.txt'
```
But it **fails**!

<br>

The **corrected version** of command above is:
```bash
sh -c 'sed -E -n -e '"'"'s/^([a-zA-Z0-9_-]+)/"\1"/p'"'"' example.txt'
```
Here, all `'` are replaced wit ``'"'"'``.

<br>

## ANSI C quoting
Character sequences of the form `$'string'` are treated as a **special kind of single quotes**.<br>
The sequence expands to string, with **backslash-escaped characters** in string replaced as specified by the **ANSI C standard**.<br>
**Backslash escape sequences**, if present, are decoded as follows:
- `\b` backspace
- `\n` newline
- `\r` carriage return
- `\t` horizontal tab
- `\v` vertical tab
- `\\` backslash
- `\'` **single quote**
- `\"` **double quote**

<br>

### Examples
#### Broken code
```bash
% A='asdf\' sdf'
quote>
^C
%
% echo $A

%
```

<br>

#### Working code
```bash
% A=$'asdf\' sdf'
%
% echo $A
asdf' sdf
%
```

<br>
