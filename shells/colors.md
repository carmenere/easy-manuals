# Escape sequences
Format of **escape sequence**: `\e[CODEm` or `\033[CODEm` or `\033[CODE1;CODE2m`.<br>
`CODE` stands for **code of color** or **code of format**.<br>

<br>

# Codes of colors
|Color|Foreground code|Background code|
|:----|:--------------|:--------------|
|Black|30|40|
|Blue|34|44|
|Cyan|36|46|
|Gray|90|100|
|Green|32|42|
|Magenta|35|45|
|Red|31|41|
|White|97|107|
|Yellow|33|43|
|Light Blue|94|104|
|Light Cyan|96|106|
|Light Gray|37|47|
|Light Green|92|102|
|Light Magenta|95|105|
|Light Red|91|101|
|Light Yellow|93|103|

<br>

# Codes of formats
|Format|Code|
|:----|:--------------|
|Reset/Normal|0|
|Bold text|1|
|Faint text|2|
|Italics|3|
|Underlined text|4|

<br>

# Tests
## Set vars
```bash
## Formating
BLINK="\033[5m"
BOLD="\033[1m"
FAINT="\033[2m"
ITALICS="\033[3m"
RESET="\033[0m"
UNDERLINE="\033[4m"
## Colors
BLACK="\033[30m"
BLUE="\033[34m"
CYAN="\033[36m"
GRAY="\033[90m"
GREEN="\033[32m"
MAGENTA="\033[35m"
RED="\033[31m"
WHITE="\033[97m"
YELLOW="\033[33m"

## Back ground colors (BG)
BG_BLACK="\033[40m"
BG_BLUE="\033[44m"
BG_CYAN="\033[46m"
BG_GRAY="\033[100m"
BG_GREEN="\033[42m"
BG_MAGENTA="\033[45m"
BG_RED="\033[41m"
BG_WHITE="\033[107m"
BG_YELLOW="\033[43m"
```

<br>

## Print out
```bash
echo "${BG_BLACK} AAAAAA ${RESET} ------ ${BLACK}${BOLD} AAAAAA ${RESET}"
echo "${BG_BLUE} AAAAAA ${RESET} ------ ${BLUE}${BOLD} AAAAAA ${RESET}"
echo "${BG_CYAN} AAAAAA ${RESET} ------ ${CYAN}${BOLD} AAAAAA ${RESET}"
echo "${BG_GRAY} AAAAAA ${RESET} ------ ${GRAY}${BOLD} AAAAAA ${RESET}"
echo "${BG_GREEN} AAAAAA ${RESET} ------ ${GREEN}${BOLD} AAAAAA ${RESET}"
echo "${BG_MAGENTA} AAAAAA ${RESET} ------ ${MAGENTA}${BOLD} AAAAAA ${RESET}"
echo "${BG_RED} AAAAAA ${RESET} ------ ${RED}${BOLD} AAAAAA ${RESET}"
echo "${BG_WHITE} AAAAAA ${RESET} ------ ${WHITE}${BOLD} AAAAAA ${RESET}"
echo "${BG_YELLOW} AAAAAA ${RESET} ------ ${YELLOW}${BOLD} AAAAAA ${RESET}"

echo "${CYAN}${BLINK} AAAAAA ${RESET}"
echo "${CYAN}${BOLD} AAAAAA ${RESET}"
echo "${CYAN}${FAINT} AAAAAA ${RESET}"
echo "${CYAN}${ITALICS} AAAAAA ${RESET}"
echo "${CYAN}${UNDERLINE} AAAAAA ${RESET}"
```