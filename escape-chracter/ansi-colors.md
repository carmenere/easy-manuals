# ANSI Graphics Mode
## Colors / Graphics Mode
|**ESC Sequence**|**Description**|
|:---------------|:--------------|
|`0`|**reset** **all** **settings**.|
|`1`|*set* **bold** mode.|
|`2`|*set* **dim**/**faint** mode.|
|`3`|*set* **italic** mode.|
|`4`|*set* **underline** mode.|
|`5`|*set* **blinking** mode|
|`7`|*set* **inverse**/**reverse** mode|
|`8`|*set* **hidden**/**invisible** mode|
|`9`|*set* **strikethrough**/**crossed out** mode.|
|`22`|*unset* **bold** mode.|
|`22`|*unset* **dim**/**faint** mode.|
|`23`|*unset* **italic** mode.|
|`24`|*unset* **underline** mode.|
|`25`|*unset* **blinking** mode|
|`27`|*unset* **inverse**/**reverse** mode|
|`28`|*unset* **hidden**/**invisible** mode|
|`29`|*unset* **strikethrough**/**crossed out** mode.|

> **Note** <br>
> Some terminals may not support some of the modes listed above.

<br>

#### Examples
```bash
ESC="\033"
CSI="${ESC}["
echo "${CSI}1m ABC"
echo "${CSI}1;3;4;9m ABC"
```

<br>

# ANSI Colors
**SGR sequences** support **3bit** colors, **8bit** colors and **24bit** colors.<br>
The original specification had **8 colors** (**3 bit**).<br>

Abbreviations:
- **FG** => **Foreground**;
- **BG** => **Background**.

<br>

## Check terminal color bits
A **database library** such as ``termcap`` or ``terminfo`` would perform a lookup to derive the capabilities of the terminal and specific escape sequences to use the capabilities.<br>
The ``$TERM`` environment variable is used to identify terminal.<br>
The ``$COLORTERM`` environment variable is used to identify colors capabilities of terminal. If terminal supports 24bit colors then var ``$COLORTERM`` will contain ``24bit`` or ``truecolor``.<br>
```bash
echo $TERM
echo $COLORTERM
```

<br>

## 3bit Colors
### Ordinary colors
|**Color**|**FG** color code|**BG** color code|
|:----|:------------|:------------|
|Black|``30``|``40``|
|Red|``31``|``41``|
|Green|``32``|``42``|
|Yellow|``33``|``43``|
|Blue|``34``|``44``|
|Magenta|``35``|``45``|
|Cyan|``36``|``46``|
|White|``37``|``47``|
|Default|``39``|``49``|

<br>

#### Examples
```bash
ESC="\033"
CSI="${ESC}["
echo "${CSI}1;3;4;9;32;43m ABC"
```

<br>

### Bright colors
|**Color**|**FG** color code|**BG** color code|
|:---------|:-----------|:------------|
|Bright Black|``90``|``100``|
|Bright Red|``91``|``101``|
|Bright Green|``92``|``102``|
|Bright Yellow|``93``|``103``|
|Bright Blue|``94``|``104``|
|Bright Magenta|``95``|``105``|
|Bright Cyan|``96``|``106``|
|Bright White|``97``|``107``|

<br>

#### Examples
```bash
ESC="\033"
CSI="${ESC}["
echo "${CSI}1;3;4;9;92;103m ABC"
```

<br>

## 8bit Colors
|CSI parameters to set color|Description|
|:-----------|:----------|
|``38;5;{ID}m``|Set **FG** color.|
|``48;5;{ID}m``|Set **GB** color.|

Where ``{ID}`` should be replaced with the **color index** from **0** to **255**.

<br>

#### Some 8bit colors indexes
```bash
Dark grey = 240
Light grey = 247
Green = 34
Yellow = 208
Red = 196
Pink = 201
White = 255
```

<br>

#### Examples
```bash
ESC="\033"
CSI="${ESC}["
echo "${CSI}1;3;4;9;48;5;122m ABC"
echo "${CSI}1;3;4;9;38;5;122m ABC"
```

<br>

#### List of all **8bit** color's indexes
```Python
ESC='\x1b'
CSI=f"{ESC}["
for i in range(0, 255):
    print (f"{CSI}38;5;{i}m{i}")
```

<br>

## 24bit Colors
More modern terminals supports **Truecolor** or **24-bit RGB**.<br>

|SI parameters to set color|Description|
|:----------------|:----------|
|`38;2;{r};{g};{b}m`|Set FG color as RGB.|
|`48;2;{r};{g};{b}m`|Set BG color as RGB.|

Where ``{r}``, ``{g}`` and ``{b}`` are values for **R**, **G** and **B** respectively.

<br>

#### Examples
```bash
ESC="\033"
CSI="${ESC}["
echo "${CSI}1;3;4;9;48;2;255;255;255m ABC"
echo "${CSI}1;3;4;9;38;2;255;255;255m ABC"
```
