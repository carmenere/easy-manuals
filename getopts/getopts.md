# `getopts`
The `getopts` is a **built-in shell command** designed for parsing **short options** (aka **single-character options**), often used within a **while** loop.<br>

<br>

Basic syntax of `getopts`:
```bash
while getopts ${OPTSTRING} opt; do case ${opt} in ... esac; done
```

<br>

The **variable** `${OPTSTRING}` defines the **options** your script or function accepts:
- each letter in the string represents an option, like `-a` or `-b`;
- if an option **requires an argument**, you must add colon `:` immediately after it;
    - `u:` in `OPTSTRING` means the `-u` option **requires an argument**, like `-u Alice`;
- option **without** a colon **doesn’t** require an argument, such option acts as a **flag**:
    - `h` in `OPTSTRING` means the `-h` option **doesn’t** require an argument;

<br>

Each time `getopts` is invoked:
- the value of the **current** option in saved to the **variable** `opt`;
- if the option **require an argument**, the `getopts` stores argumet in the **variable** `OPTARG`;
    - if the option that was found **does not** require an argument, `OPTARG` will be **unset**;

<br>

For example, if `-u Alice` is passed, the `${opt}` will hold `u`, and the `${OPTARG}` will hold `Alice`.<br>
Inside your script, you’ll typically use a `case ${opt}` statement to handle the option and decide what to do for each option.<br>

Example:
```bash
function xxx() {
  local OPTSTRING OPTIND opt OPTARG
  OPTSTRING=":x:y:"
  while getopts ${OPTSTRING} opt; do
    echo "opt=$opt"
    case ${opt} in
      x) echo "OPTARG = ${OPTARG}"; if [ "${OPTARG:0:1}" = "-" ]; then echo "Option ${opt} requires an argument"; return 99; fi
         echo "Option -x was triggered, Argument: ${OPTARG}";;
      y) echo "OPTARG = ${OPTARG}"; echo "Option -y was triggered, Argument: ${OPTARG}";;
      :) echo "Option -${OPTARG} requires an argument."; return 1;;
      ?) echo "Invalid option: -${OPTARG}."; return 1 ;;
    esac
  done
}
```

The `\?` catches **invalid options** (like `-z`) and shows an error message.<br>
The `:` catches cases when **required arguments are misiing**, like `-u` without a value.<br>

`getopts` **does not** support **optional arguments** for options, in other words, if option must have argument any next string will be intepreted as its argument.<br>
If we call xxx from the example above like `xxx -x -y` then `-y` will be interpreted as argument of `-x` option!<br>

`getopt` is an **external binary** that is more powerful and flexible. It can handle both **short** and **long** options, and allows for more complex parsing scenarios.<br>

<br>