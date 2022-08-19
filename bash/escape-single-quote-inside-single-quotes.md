# Escaping ``'`` in bash
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