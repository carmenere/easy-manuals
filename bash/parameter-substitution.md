# Parameter substitution
- `${VAR%/*}` returns directory part from `${VAR}`, it cuts **shortest** pattern `/*` **from the end**.
- `${VAR##*/}` returns file part from `${VAR}`, it cuts **longest** pattern `*/` **from the begining**.

<br>

Consider var: `VAR=/foo/bar/file.txt`:
1. Get only **file part** from the path: 
```bash
echo ${VAR##*/}
file.txt
```
1. Get only **directory part** from the path:
```bash
echo ${VAR%/*}
/foo/bar
```
