# Table of contents
<!-- TOC -->
- [Table of contents](#table-of-contents)
- [Status indicators for files](#status-indicators-for-files)
- [`git log`](#git-log)
  - [List all commits as graph and show only short hash and message](#list-all-commits-as-graph-and-show-only-short-hash-and-message)
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

## List all commits as graph and show only short hash and message
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
