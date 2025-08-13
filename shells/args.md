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
* [POSIX](#posix)
  * [Utility general syntax](#utility-general-syntax)
  * [Argument](#argument-1)
  * [Operand](#operand)
  * [Option](#option)
  * [Option-Argument](#option-argument)
  * [Flag](#flag)
  * [Double dash](#double-dash)
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

<br>

# POSIX
[POSIX.1-2017](https://pubs.opengroup.org/onlinepubs/9699919799.2018edition/basedefs/V1_chap03.html)


## Utility general syntax
`utility_name[-a][-b][-c option_argument] [-d|-e][-f[option_argument]][operand...]`

<br>

## Argument
In the shell command language, a parameter passed to a utility as the equivalent of a single string in the argv array created by one of the exec functions.<br>
An argument is one of the **options**, **option-arguments**, or **operands** following the command name.<br>

<br>

## Operand
**Operand** is a **positional argument** (aka **non-option argument**) of command itself.<br>
Operands generally follow the options in a command line.<br>


<br>

## Option
An argument to a command that is generally used to specify changes in the utility's default behavior.<br>

<br>

## Option-Argument
A parameter that follows certain options. In some cases an option-argument is included within the same argument string as the option-in most cases it is the next argument.<br>

<br>

## Flag
A **flag** is an **option** that **has no option-argument**.<br>

<br>

## Double dash
More precisely, a double dash `--` is used to indicate **the end of options**, after which **only operands** are accepted.<br>
In other words, **any following arguments hould be treated as operands**, even if they begin with the `-` character.<br>