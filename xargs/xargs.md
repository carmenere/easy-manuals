`` ... | xargs ${CMD}`` has 2 modes.

# Mode 1 (by default)
- xargs reads ``stdin``;
- forms args list using separators (by default) ``\n``, ``\t``, ``\s``;
- passes **all args** to commnad ``${CMD}``.

<br>

### Examples
```bash
echo -e "A\nB C" | xargs echo
```

Output:
```bash 
A B C
```

<br>

# Mode 2
- xargs reads ``stdin``;
- forms args list using separators (by default) ``\n``, ``\t``, ``\s`` and remembers all line feeds for ``-L`` option;
- passes **N args** to commnad ``${CMD}`` if **-n**<N> option was specified or passes **N lines** to commnad ``${CMD}`` if **-L**<N> option was specified.

<br>

### Examples
#### Example 1
```bash
echo -e "A\nB C" | xargs -L1 echo
```

Output: 
```bash 
A
B C
```

#### Example 2
```bash
echo -e "A\nB C" | xargs -n2 echo
```

Output: 
```bash 
A B
C
```

# Options
|Option|Description|
|:-----|:----------|
|``-d<delimeter>``|Sets ``<delimiter>`` for args read from ``stdin``. Example: ``-d,``. <br>By default ``xargs`` uses ``\n``, ``\t``, ``\s`` as delimiter for args read from ``stdin``.|
|``-I{}``|Sets symbol ``{}`` for **placeholder**. **Placeholder** can be inserted in any place in command ``${CMD}``.|
|``--null``|Tells ``xargs`` use **null byte** as string separator for stream in ``stdin``.|
|``-P<N>``|Runs <N> threads.|
