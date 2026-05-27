# Table of contents
<!-- TOC -->
- [Table of contents](#table-of-contents)
- [Commiter vs. Author](#commiter-vs-author)
- [Commit message: subject vs body](#commit-message-subject-vs-body)
- [`git log`](#git-log)
  - [Status indicators for files for `--name-status` option](#status-indicators-for-files-for---name-status-option)
  - [Date and time formats](#date-and-time-formats)
  - [`--pretty=format`](#--prettyformat)
  - [`--first-parent`](#--first-parent)
  - [List all commits as graph](#list-all-commits-as-graph)
  - [Create alias `git mlog`](#create-alias-git-mlog)
  - [Show commits in chronological order](#show-commits-in-chronological-order)
  - [Show commits in reverse chronological order](#show-commits-in-reverse-chronological-order)
  - [List all commits that modify a file](#list-all-commits-that-modify-a-file)
  - [Show diff (patch) per every commit for a file](#show-diff-patch-per-every-commit-for-a-file)
  - [List all commits where specifi string was added or removed in a file](#list-all-commits-where-specifi-string-was-added-or-removed-in-a-file)
  - [List all commits and status indicators of files each commit](#list-all-commits-and-status-indicators-of-files-each-commit)
  - [List all commits filered by status indicator](#list-all-commits-filered-by-status-indicator)
  - [Identify who has changed code](#identify-who-has-changed-code)
  - [Show commit](#show-commit)

<br>

# Commiter vs. Author
The **author** is the person who **originally wrote the code** or **made the changes**.<br> 
The **committer** is the person who **added the changes to the repository**.<br>

**Person who perfrm** *cherry-pick*, *rebass* and *merge* **becomes** the **committer**, but **author stays the same**.<br>

So, the **committer date** represent **when** the **commit was actually applied to the repository** (e.g., during a *cherry-picking*, *rebasing* or *merging*).<br>

<br>

# Commit message: subject vs body
A **commit message** consists of:
- **header** (aka **subject**, **commit title**) is the **first line** of the commit message;
  - must be written in the **imperative mood** (e.g., "Fix bug" instead of "Fixed bug");
  - **formatting**:
    - **max length** is **50** characters;
    - capitalized;
    - ends without a period;
- **body** is **everything after** the subject line;
  - **formatting**:
    - lines are typically wrapped at **72** characters;

<br>

# `git log`
The `git log` searches in the **current branch**, to search the entire repository history add `--all`, e.g. `git log --all -- <file>`

<br>

## Status indicators for files for `--name-status` option
The option `--name-status` displays **status indicators** for files in `git log`/`git show`:
- `R<num>` (Renamed)
- `C` (Copied)
- `M` (Modified)
- `A` (Added)
- `D` (Deleted)
- 

<br>

**Note** that `--name-status` displays **similarity score** for renamed files in format: `R<number>`:
- `R100` indicates the file was **moved** or **renamed** with **100%** identical content;
- `R90` indicates the file was **moved** or **renamed** with **90%** identical content, in other words, **10%** of file **was modified** during the rename;

<br>

**By default**, Git requires at least **50% similarity** to classify a **deletion** and **addition** as **rename**.<br>

<br>

## Date and time formats
- `--date=<format>`
  - `iso` or `iso8601`
  - `iso-strict` or `iso8601-strict`
  - `relative` shows dates **relative to the current time**, e.g. “2 hours ago”;
    - the `-local` suffix has no effect;
  - `rfc` or `rfc2822`
  - `short` shows **only** the **date**, in `YYYY-MM-DD` format, **without time**;
  - `raw` shows the date as *seconds since the epoch* **with** *local timezone* as an offset from UTC;
  - `unix` shows the date as *seconds since the epoch* **without** *local timezone*;
  - the `-local` **suffix** does not affect `raw` and `unix`, because the *seconds since the epoch* value is **always measured in UTC**;
  - **by default**, dates are shown in the **original time zone** (either committer’s or author’s), **but** if `-local` **suffix** is appended to the format (e.g., `iso-local`), the **user’s local time zone** is used instead:
    - `default-local`
    - `iso-local`
    - `iso-strict-local`
    - `local-local`
    - `raw-local`
    - `relative-local`
    - `rfc-local`
    - `short-local`

<br>

**Set** *custom date and time format*:
```bash
git config --global log.date local
```

**Unset** **to default**:
```bash
git config --global --unset log.date
```

<br>

To view the log in a time zone **other than current** one (e.g., UTC or a specific region), you can temporarily set the `TZ` environment variable before the command:
- `TZ=UTC git log --date=local`;
- `TZ=America/New_York git log --date=local`;

<br>

## `--pretty=format`
**Examples**:
```bash
git log --pretty=format:"%C(color)%h%C(reset) | %ad | %aD | %at | %aI | %as | %ar"
git log --pretty=format:"%C(color)%h%C(reset) | %cd | %cD | %ct | %cI | %cs | %cr"
```

<br>

**Placeholders** for `--pretty=format`:
- `%h`: is a **short commit hash**;
- `%H`: is a **full commit hash**
- `%s`: is a **subject**;
- `%b`: is a **body**;
- `%B`: is a **full commit message**: **subject** + **body**;
- **color** placeholder:
  - `%C(color attribute)<element>%C(reset)`: specifies the **color** and/or **attribute** for `<element>`, the `%C(reset)` is a stop marker;
  - **example**: `%C(bold blue)<%an>%C(reset)`;
    - **colors**: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, and `white`;
    - **attributes**: `bold`, `dim`, `ul` (underline), `blink`, and `reverse`;
- **committer** placeholders:
  - `%cn`: *committer* **name**;
  - `%ce`: *committer* **email**;
  - `%cd`: *committer* **date**, **respects** `--date=<format>` option;
  - `%cD`: *committer* **date**, **RFC2822** style, e.g. `Mon, 2 Jun 2025 17:04:27 +0000`;
  - `%cr`: *committer* **date**, **relative**, e.g. `18 minutes ago`;
  - `%ct`: *committer* **date**, **UNIX** timestamp;
  - `%ci`: *committer* **date**, **ISO 8601** format;
  - `%cI`: *committer* **date**, **strict ISO 8601** format;
  - `%cs`: *committer* **date**, **short** format (`YYYY-MM-DD`);
- **author** placeholders:
  - `%an`: *author* **name**;
  - `%ae`: *author* **email**;
  - `%ad`: *author* **date**, **respects** `--date=<format>` option;
  - `%aD`: *author* **date**, **RFC2822** style, e.g. `Mon, 2 Jun 2025 17:04:27 +0300`;
  - `%ar`: *author* **date**, **relative**, e.g. `18 minutes ago`;
  - `%at`: *author* **date**, **UNIX** timestamp;
  - `%ai`: *author* **date**, **ISO 8601** format;
  - `%aI`: *author* **date**, **strict ISO 8601** format;
  - `%as`: *author* **date**, **short** format (`YYYY-MM-DD`);

<br>


## `--first-parent`
- `--first-parent` ignores the individual commits brought from merged branch and prints out only the commits from **current branch** (**upstream**):
```bash
git log -10 --graph --pretty=format:"%C(yellow)%h%Creset [%cd] %C(green)[%cn]%Creset  %s" --date=iso --first-parent
```

<br>

## List all commits as graph
- **for current branch**:
```bash
git log -10 --graph --oneline
```

<br>

- **for specific branch** `branch_name`:
```bash
git log -10 --graph --oneline <branch_name>
```

<br>

## Create alias `git mlog`
```bash
git config --global alias.mlog "log --graph --pretty=format:'%C(yellow)%h%Creset [%cd] %C(green)[%cn]%Creset  %s' --date=iso-local --first-parent"
```

**Usage** of alias:
```bash
git mlog -10
git mlog -10 <branch>
```

<br>


## Show commits in chronological order
```bash
git log --pretty=format:"%H %d" --reverse --ancestry-path 6865efd4759b4cd5349f9e6b014017e099383e84^..master
6865efd4759b4cd5349f9e6b014017e099383e84  (tag: release-1.7.1)
437cb7b6631c26ad74f992c4745b42ae2836105b
a22a4f4847ff04005ba1b50b227933e6e816c55d  (tag: release-1.7.2)
```

<br>

## Show commits in reverse chronological order
```bash
git log --pretty=format:"%H %d"  6865efd4759b4cd5349f9e6b014017e099383e84
6865efd4759b4cd5349f9e6b014017e099383e84  (tag: release-1.7.1)
e36718de4b3570b8174bb76787ca6c73386bbb9f
215497a467a34003c5259b832da4678f33d163b4  (tag: release-1.7.0)
```

<br>

## List all commits that modify a file
```bash
git log -- <file>
```

<br>

If file was renamed in the past add `--follow`:
```bash
git log --follow -- <file>
```

<br>

## Show diff (patch) per every commit for a file
```bash
git log -p -- <file>
```

<br>

## List all commits where specifi string was added or removed in a file
- **exact match**:
```bash
git log -S "text" -- <file>
```
- **regex**:
```bash
git log -G "text" -- <file>
```

<br>

## List all commits and status indicators of files each commit
```bash
git log --all --full-history --name-status
```

<br>

## List all commits filered by status indicator
```bash
git log --all --full-history  --diff-filter=R -- "**/src/*foo.rs"
```

<br>

## Identify who has changed code
- **full file**:
```bash
git blame <file>
```
- **from line 10 to line 20**:
```bash
git blame -L 10,20 <file>
```

<br>

## Show commit
- *commit info* + **diff**
```bash
git show d0d540c7f9
```

<br>

- *commit info* **only**
```bash
git show -s d0d540c7f9
```

<br>

- *commit info* + **changed files** + **statistic per each file**
```bash
git show --stat d0d540c7f9
```

<br>

- *commit info* + **changed files**
```bash
git show --name-only d0d540c7f9
```

<br>

- *commit info* + **status indicators** for each file:
```bash
git show --name-status d0d540c7f9
```
