# Parameter substitution
- `${VAR%/*}` returns directory part from `${VAR}`, it cuts **shortest** pattern `/*` **from the end**.
- `${VAR##*/}` returns file part from `${VAR}`, it cuts **longest** pattern `*/` **from the begining**.

<br>

Consider var: `VAR=/foo/bar/file.txt`.<br>

<br>

## Cut file part from path
Get only **file part** from the path: 
```bash
echo ${VAR##*/}
file.txt
```

<br>

Alternative:
```bash
echo "${VAR}" | rev | cut -d'/' -f 1 | rev
```

<br>

## Cut directory part from path
Get only **directory part** from the path:
```bash
echo ${VAR%/*}
/foo/bar
```
