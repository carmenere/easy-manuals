# In-band vs. Out-of-band signaling
In telecommunications:
- **in-band signaling** is the sending of **control information** within **the same band** or **channel** used for data.<br>
- **out-of-band signaling**is the sending of **control information** over a **different channel**, or even over a **separate network**.<br>

<br>

# ANSI escape sequences
**ANSI escape sequences** (or just **ANSI sequences**) are *character sequences* that starting with an **ASCII escape character**.<br>

**ANSI escape sequences** are a standard for *in-band signaling* to control:
- cursor **location**;
- **color**;
- **font** styling;
- other options of *terminals* and *terminal emulators*. 

**ANSI sequences** were introduced in the 1970s to replace vendor-specific sequences and became widespread in the computer equipment market by the early 1980s.<br>

<br>

## ASCII escape character
The **ASCII escape character** (aka **Escape starts**) is used in many devices or terminals to start a series of characters called a **control sequence** or **escape sequence**.<br>
The **ASCII escape character** has abbreviation ``ESC``.<br>
The ``ESC`` **character** has following serial numbers in ASCII table: *dec*:``27``, *hex*:``0x1B``, *octal*:``0o33``.<br>
The **caret notation** of ``ESC`` **character**  is ``^[``.<br>

<br>

### Caret notation
**Caret notation** is a notation for *control characters* in ASCII.<br>
The notation consists of a caret ``^`` followed by a **single printable character**.<br>
ASCII code of character after ``^`` is equal to the **its control code + code of** ``A``.<br>

<br>

#### Example
**ASCII code** of ``ESC`` is ``[``, because ``0x1B`` + ``0x40`` = ``5B`` and ``5B`` code has symbol ``[``.<br>

<br>

## Sequences
There are some types of **escape sequences**:
|Type|Description|
|:---|:----------|
|``ESC``|**Fe Escape sequences** are all sequences starting with ASCII character ``ESC``|
|``CSI``|**Control Sequence Introducer sequences** are all sequences starting with ``ESC [``|
|``DCS``|**Device Control String sequences** are all sequences starting with ``ESC P``|
|``OSC``|**Operating System Command sequences** are all sequences starting with ``ESC ]``|

<br>

## C0 and C1 control code sets
Some **single-byte** *control characters* were initially defined as **part of ASCII**:
- **C0 control code set** defines *control characters* in 7-bit ASCII table (first **32** codes and last **127** code). **C0 set** was originally defined in **ISO 6429** standard;
- **C1 control code set** defines *control characters* in 8-bit ASCII table, **C1 set** was originally defined in **ECMA-48** standards.

Now **ISO 6429** and **ECMA-48** are compatible.<br>

Examples of some **C0 control codes**:
- ``0x0A`` is the **line feed** (``LF``);
- ``0x0D`` is the **carriage return** (``CR``);
- ``0x1B`` is the **ASCII escape character** (``ESC``).

<br>

## Fe Escape sequences
**Fe Escape sequences** is the ``ESC`` is followed by **one** ASCII character with serial number in range [``0x40``-``0x5F``].<br>
Every **Fe escape sequence** has corresponding character in **C1 set**.<br>
There is mapping between **Fe Escape sequences** and **C1 control codes set**.<br>

<br>

# CSI sequences
**CSI** = **Control Sequence Introducer**.<br>
**CSI sequence** is the ``ESC [`` is followed by **any** number of **parameter bytes**, then by **any** number of **intermediate bytes**, then **finally** by a **single** **final byte**.<br>

Notes:
- serial numbers of ASCII characters allowed for **parameter bytes** are belong to range ``0x30``–``0x3F`` (``0–9:;<=>?``);
- serial numbers of ASCII characters allowed for **intermediate bytes** are belong to range ``0x20``–``0x2F`` (``space``, ``!"#$%&'()*+,-./``);
- serial numbers of ASCII characters allowed for **final bytes** are belong to range ``0x40``–``0x7E`` (``@A–Z[\]^_`a–z{|}~``).

<br>

All *common sequences* just use the **parameters** as a **series** of **semicolon-separated numbers** such as ``1;2;3``.<br>

**Missing numbers** are treated as ``0``, e.g., ``ESC[1;;3`` treated as ``ESC[1;0;3``.

<br>

## SGR sequences
**SGR** = **Select Graphic Rendition**.<br>
**SGR sequence** is a sequence that has following format: ``CSI n m``.<br>
**SGR sequence** is used to set **display attributes**. Each display attribute remains in effect until a following occurrence of ``SGR`` resets it.<br>
If **no** codes are given, ``CSI m`` is treated as ``CSI 0 m`` and means **reset all display attributes to their defaults**.<br>

> **Note**: **Several** attributes can be set in the same sequence, separated by **semicolons**.<br>

<br>

#### Example
Code below:
```bash
ESC="\033"
CSI="${ESC}["
echo "${CSI}2m${CSI}44m ABC" 
```

is **equal** to:

```bash
ESC="\033"
CSI="${ESC}["
echo "${CSI}2;44m ABC" 
```
