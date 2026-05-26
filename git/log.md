# Table of contents
<!-- TOC -->
- [Table of contents](#table-of-contents)
- [Status indicators for files](#status-indicators-for-files)
- [`git log`](#git-log)
  - [`--pretty=format`](#--prettyformat)
  - [Example: hash \[date\] \[commiter\] message](#example-hash-date-commiter-message)
  - [List all commits as graph](#list-all-commits-as-graph)
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

# Status indicators for files
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

# `git log`
The `git log` searches in the **current branch**, to search the entire repository history add `--all`, e.g. `git log --all -- <file>`

<br>

## `--pretty=format`
`git log --pretty=format:"%h %ad- %s [%an]"`

Here:
- `%h`: short commit hash
- `%H`: full commit hash
- `%s`: subject (aka commit title)
- `%b`: body (commit message without title)
- `%B`: full commit message: title + body
- `%an`: author name
- `%ae`: author email 
- `%cn`: committer name
- `%ce`: committer email

<br>

| Date placeholder | Format                             | Example                                    |
|:-----------------|:-----------------------------------|:-------------------------------------------|
| %ad, %cd         | respects `--date=<format>` option  | **Mon** **Jun** 2 17:04:27 **2025** +0300  |
| %aD, %cD         | **RFC2822**                        | **Mon**, 2 **Jun** **2025** 17:04:27 +0300 |
| %at, %ct         | **UNIX** timestamp                 | 1748873067                                 |
| %aI, %cI         | strict **ISO 8601** format         | **2025**-06-02T17:04:27+03:00              |
| %as, %cs         | **short** format (YYYY-MM-DD)      | **2025**-06-02                             |
| %ar, %cr         | **relative**                       | 18 minutes ago                             |


The letter `a` in _date placeholder_ means **author date**: the date when the **original changes** were made.<br>
The letter `c` in _date placeholder_ means **committer date**: the date when the changes were made, for example, during a rebase or amend operation.<br>

<br>

**Example**:
```bash
git log --pretty=format:"%H | %ad | %aD | %at | %aI | %as | %ar"
git log --pretty=format:"%H | %cd | %cD | %ct | %cI | %cs | %cr"
```

<br>

## Example: hash [date] [commiter] message
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
