# Table of contents
<!-- TOC -->
- [Table of contents](#table-of-contents)
- [Commiter vs. Author](#commiter-vs-author)
- [Commit message: subject vs body](#commit-message-subject-vs-body)
- [`git log`](#git-log)
  - [Date and time formats](#date-and-time-formats)
  - [`--pretty=format`](#--prettyformat)
  - [`--first-parent`](#--first-parent)
  - [List all commits as graph](#list-all-commits-as-graph)
  - [Create alias `git mlog`](#create-alias-git-mlog)
  - [Show diff (patch) per every commit for a file](#show-diff-patch-per-every-commit-for-a-file)
  - [Filtering](#filtering)
    - [By branch](#by-branch)
    - [By author or committer](#by-author-or-committer)
    - [By date](#by-date)
    - [By commit messages](#by-commit-messages)
    - [By file or directory](#by-file-or-directory)
    - [By content](#by-content)
    - [By status indicator](#by-status-indicator)
      - [Status indicators](#status-indicators)
- [`git blame`](#git-blame)
- [`git show`](#git-show)

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

## Show diff (patch) per every commit for a file
```bash
git log -p -- <file>
```

<br>

## Filtering
### By branch
```bash
git log <branch_name>
```

<br>

### By author or committer
- by **author**:
```bash
git mlog --after="2025-05-05" --before="2026-05-06" --author="Anton Romanov"
```
- by **committer**:
```bash
git mlog --after="2025-05-05" --before="2026-05-06" --committer="Anton Romanov"
```
- **exclude an author**:
```bash
git mlog --after="2025-05-05" --before="2026-05-06" --author='^(?!Anton Romanov)' --perl-regexp
```

<br>

### By date
- **after a date**: `--since=` or `--after=`
```bash
git mlog --since="2026-05-05" --committer="Anton Romanov"
git mlog --after="2026-05-05" --committer="Anton Romanov"
```
- by **before a date**: `--until=` or `--before=`
```bash
git mlog --until="2026-05-20" --committer="Anton Romanov"
git mlog --before="2026-05-20" --committer="Anton Romanov"
```
- **date range**:
```bash
git mlog --since="2026-05-05" --until="2026-05-20" --committer="Anton Romanov"
git mlog --after="2026-05-05" --before="2026-05-20" --committer="Anton Romanov"
```

<br>

### By commit messages
- **case sensitive search in commit messages**: `--grep=` (**case sensitive**)
```bash
git log --grep="pattern"
```
- **case insensitive search in commit messages**: add the `-i` flag:
```bash
git log -i --grep="PATTERN"
```
- **invert search**: search commits that **do not match** the `pattern`
```bash
git log --invert-grep --grep="pattern"
```

<br>

### By file or directory
- lists all commits that modify a **specific file**:
```bash
git log -- path/to/file
```
- lists all commits that modify files in a **specific directory**:
```bash
git log -- path/to/dir/
```
- **by glob pattern**:
```bash
git log -- "**/src/*foo.rs"
```
- **by line range**: shows changes specifically to lines **15** through **25**:
```bash
git log -L 15,25:path/to/file
```

<br>

If file was **renamed** in the past add `--follow`:
```bash
git log --follow -- path/to/file
```

<br>

### By content
- **exact match** in the **specific file** `path/to/file`:
```bash
git log -S "pattern" -- path/to/file
```
- **exact match** in **any file**:
```bash
git log -S "pattern" -- path/to/file
```
- **regex** in the **specific file** `path/to/file`:
```bash
git log -G "pattern" -- path/to/file
```
- **regex** in **any file**:
```bash
git log -G "pattern"
```

<br>

### By status indicator
```bash
git log --diff-filter=R -- "**/src/*foo.rs"
```

<br>

#### Status indicators
**Git status indicators** tell you the **state of files**.<br>

<br>

The `git log --name-status` lists the modified files for each commit along with their **status letter**:
```bash
git mlog --name-status
```

<br>

Git uses **special notation** to represent the **status indicators**:
- `A`: **Added**;
- `C`: **Copied**;
- `D`: **Deleted**;
- `M`: **Modified**;
- `R<num>`: **Renamed**;
- `T`: **Type changed**, e.g., a *regular file* became a *symbolic link*
- `U`: **Unmerged**, the file has **unresolved merge conflicts**;

<br>

**Note** that `--name-status` displays **similarity score** for **renamed** files in format: `R<number>`:
- `R100` indicates the file was **moved** or **renamed** with **100%** identical content;
- `R90` indicates the file was **moved** or **renamed** with **90%** identical content, in other words, **10%** of file **was modified** during the rename;

<br>

**By default**, Git requires at least **50% similarity** to classify a **deletion** and **addition** as **rename**.<br>

<br>

# `git blame`
The `git blame` command identifies who has changed code:
- **full file**:
```bash
git blame <file>
```
- **from line 10 to line 20**:
```bash
git blame -L 10,20 <file>
```

<br>

# `git show`
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
