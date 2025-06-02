# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [IFS](#ifs)
* [Argument](#argument)
  * [Unix style](#unix-style)
  * [GNU style](#gnu-style)
  * [Nodash](#nodash)
  * [Bare hyphen](#bare-hyphen)
  * [Terminating double hyphen](#terminating-double-hyphen)
* [Example](#example)
<!-- TOC -->

<br>

# IFS
**IFS** (**Internal Field Separator**) is the special shell variable which determines shell how **split** **sequence of characters** into **words**.<br>
The **default value** of **IFS** is a three-character string comprising a **space** (`\s`), **tab** (`\t`), and **newline** (`\n`).<br>

<br>

# Argument
Shell splits (by **IFS**) **every command** into an **array of strings** named **utility's arguments** (or just **arguments**):
- `argument 0` is the **path to binary**;
- `argument 1`, the **first word** following the command;
- and so on;

<br>

**Arguments** may be interpreted as **options**, **option-arguments**, and **operands** (aka **positional parameters**).<br>

Any remaining arguments after the options and their parameters are commonly called **operands** (aka **positional parameters**) and the **order** in which they are given is significant.<br>

<br>

## Unix style
The **Unix style** uses **single letters** preceded by a **single hyphen** `-` for **options** (aka **short-form options**).<br>
If *option* has **no parameter** it's called a **flag**.<br>
*Option* may have a **parameter** (aka **option argument**) followed the *option* and separated by whitespace. A parameter is an argument that provides some **value** to *option*.<br>

**Flags** can be can be **gathered together**, e.g., if `-a` and `-b` are **flags**, `-ab` is correct and equal to `-ab`.<br>

<br>

## GNU style
The **GNU style** uses **option keywords** (rather than letters) preceded by **two hyphens** `--` for **options** (aka **long-form options**).<br>
An **option argument** (if any) can be separated by either **whitespace** or a **equal** (`=`) character.<br>

If you are using the *GNU style*, it is **good practice** to support single-letter equivalents for at least the most common options.<br>

<br>

## Nodash
Some programs use other conventions and **options not preceded by a dash**.
For example, `tar` and `dd` accept options **without** a dash:
- `tar cvzf /tmp/somefile.tgz some/directory`;
- `dd if=/some/file of=/another/file bs=16k count=200`;

<br>

## Bare hyphen
Many utils accept a **bare hyphen**, not associated with any option letter, to read from **standard input**.

<br>

## Terminating double hyphen
A double hyphen can be used as a **signal** to **stop option interpretation** and **treat following sequence of characters literally**.<br>

<br>

> Note:<br>
> If you invoke `--` in place where shell parser expects argument for some option then parser will interpret `--` as option argument.<br>
> So, `--` must be used as **last operand**.<br>

<br>

# Example
Consider the command `ls -I README -l foo 'bar car' baz`:
- it has **7 arguments**: `/usr/bin/ls`, `-I`, `README`, `-l`, `foo`, `bar car`, `baz`;
- the `-l` and `-I` are **options**;
- the `-I` has a **parameter** `README`;
- `foo`, `bar car` and `baz` are **opernads**;
