# `getopt`
The `getopt` is a **GNU tool**. It supports both **short options** and **long options**.<br>

<br>

For MacOS: `brew install gnu-getopt`.<br>

<br>

Basic syntax of `getopt`:
```bash
OPTS=$(getopt [options] -- "$@")
eval set -- "${OPTS}"
while true; do
  case "$1" in

  esac
done
```

<br>

`OPTS=$(getopt [options] -- "$@")`: This parses the command-line arguments according to the specified options.<br>
`eval set -- "${OPTS}"`: This resets the positional parameters to the parsed options.<br>
The `while` loop processes each option:
- each case matches an option and sets the corresponding variable;
- `shift` moves to the next option;
- `--` marks the end of options; anything after it is a non-option argument;
- `break` exits the loop after processing all options;

<br>

Common `getopt` options include:
- `-o "options"`: specifies the **short options** your script accepts (e.g., `-o "hvo:"`);
- `--long "options"`: specifies the **long options** your script accepts (e.g., `--long "help,verbose,output:"`);
- `-n "name"`: the name to use in **error messages** (usually your script name or function name);

<br>

The **one** colon `:` after the option means that option **requires an argument**.<br>
The **double** colon `::` after the option means that option **requires an argument**, but argument can be **optional**.<br>

<br>

```bash
function yyy() {
  OPTS=$(getopt -o f::d::h --long file::,directory::,help -n 'yyy' -- "$@")
  if [ $? -ne 0 ]; then
    echo "Failed to parse options" >&2
    return 99
  fi
  eval set -- "${OPTS}"
  FILE=""
  DIRECTORY=""
  HELP=false
  while true; do
    case "$1" in
      -f|--file) echo "FILE"; FILE="$2"; shift 2;;
      -d|--directory) echo "DIRECTORY"; DIRECTORY="$2"; shift 2;;
      -h|--help) echo "HELP"; HELP="$2"; shift;;
      --) shift; break;;
      *) echo "Unknown option $1"; return 99;;
    esac
  done
}
```
