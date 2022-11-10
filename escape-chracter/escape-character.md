# Metacharacter
A **metacharacter** is a character that has a **special meaning** to a computer program, such as a shell interpreter or a regular expression (regex) engine.
The term **to escape a metacharacter** means to make the *metacharacter* **ineffective**, i.e., to **drop** its **special meaning** and to **treat** it **literally** *inside some expression*.<br>

#### Example (regex)
The **regular expression** ``.`` will match ``A``, ``z``, ``3``, ``;`` and so on, because ``.`` is a **metacharacter** and it means **any symbol**.<br>
However, if the ``.`` is **escaped**, it will become ordinary symbol and will be interpreted **literally** as ``.`` and the **regular expression** ``\.`` will only match the symbol ``.``.<br>

So, **backslash** ``\`` is used **to escape metacharacters** in *regex expressions*.<br>

<br>

# Escape character
**Escape character** is a character that **alters interpretation** on the *following characters* **in** a character **sequence**.<br>
An **escape character** is a **particular** case of *metacharacters*.<br>
Generally, the judgement of whether something is an **escape character** or **not** **depends on the context**.<br>
**Escape sequence** is a sequence of characters that **starts** with an **escape character**, such character sequence is interpreted **differently** from the same sequence but without the **escape character** in the begining.

<br>

Usage:
- *in the telecommunications* **escape sequences** are used to encode a syntactic entities, such as terminal and device's commands, which **cannot** be directly represented **by the alphabet**.
- (*in programming and data formats* **escape sequences** are used to represent characters which **cannot** be typed in the current **context**.

<br>

# Control character
**Written symbols** of some *character set* (aka **printable characters**), represent
- **letters**;
- **digits**;
- **punctuation marks**;
- and **a few miscellaneous symbols**.

<br>

In computing and telecommunication, a **control character** (aka **non-printing character**, **NPC**) is a **code point** (a **number**) in a *character set*, that does **not** represent a *written symbol*.<br>

To display **control character** *escape character* must be used.

<br>

# Control vs. Escape characters
Generally, an **escape character** is not **control characters**, nor vice versa.<br>

ASCII table layout: 
- ASCII reserves the **first** **32** codes (**from** *hex*:``0`` **to** *hex*:``1F``) and **last code** (*dec*:``127`` or *hex*:``7F``) as **NPC**, e.g., character *hex*:``0A`` represents the **line feed**, and character *hex*:``0D`` represents **carriage return**.
- there are **95** **printable** characters in ASCII table, **from** *hex*:``20`` **to** *hex*:``7E``;

<br>

Notes:
- *in the telecommunications* escape sequences can be control sequencies if they have special meaning for device or terminal;
- *in programming* *escape characters* are **graphic** and hence are **not** *control characters*. 
- *control characters* that are **not** *used for escaping* other are **not** *escape characters*.
