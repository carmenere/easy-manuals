# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [git init](#git-init)
* [git clone](#git-clone)
* [git config](#git-config)
  * [Set value](#set-value)
  * [List settings](#list-settings)
  * [Mandatory options to set](#mandatory-options-to-set)
  * [Unset specific option](#unset-specific-option)
  * [Get option's value](#get-options-value)
* [git reset](#git-reset)
  * [git reset --hard ref](#git-reset---hard-ref)
  * [git reset --mixed ref](#git-reset---mixed-ref)
  * [git reset --soft ref](#git-reset---soft-ref)
  * [git commit](#git-commit)
  * [git commit --amend](#git-commit---amend)
* [git restore](#git-restore)
* [git revert](#git-revert)
* [git clean](#git-clean)
  * [Examples](#examples)
* [git tag](#git-tag)
* [git describe](#git-describe)
<!-- TOC -->

<br>

# git init
`master` or `main` are the default names for a **initial branch** when you run `git init`.<br>

<br>

# git clone
`origin` is the **default name** for a **remote repository** when you run `git clone`.<br>

`git clone -o foo <URI>` then name `foo` will be used instead `origin`.<br>
`git clone --recurse-submodules URI` performs clone with **submodules**.<br>

<br>

# git config
|File|Description|
|:---|:----------|
|`/etc/gitconfig`|`git config --system` uses this file.|
|`~/.gitconfig` or `~/.config/git/config`|`git config --global` uses this file.|
|`.git/config`|`git config --local` uses this file.|

<br>

## Set value
There is following syntax to set parameter:
- `git config --%level% section.parameter value`
- `git config --%level% section.subsection.parameter value`

<br>

## List settings
`git config --list --show-origin` shows settings and their files.

<br>

## Mandatory options to set
There are 2 options that must be set `user.name` and `user.email`:
- `git config --global user.name "John Doe"`
- `git config --global user.email johndoe@example.com`

<br>

## Unset specific option
`git config --unset diff.renames`

<br>

## Get option's value
`git config --get core.filemode`

<br>

# git reset
## git reset --hard ref
`git reset --hard ref` resets **entire repository** to the commit `ref`:
1. Move **current branch** (`HEAD`) to the `ref`. Actually this step cancels `git commit`.
2. Updates **index** by content of last commit in **current branch** (**current branch** here is point to `ref`). Actually this step cancels `git add` and `git commit`.
3. Updates **working directory** by content of last commit in **current branch** and **deletes** all **untracked files**. Actually this step cancels `git add`, `git commit` and changes in **working directory**.

<br>

## git reset --mixed ref
This mode is used **by default**.<br>
`git reset --mixed ref` stops after **step 2**. Actually this step cancels `git add` and `git commit`.

<br>

## git reset --soft ref
`git reset --soft ref` stops after **step 1**. Actually this step cancels `git commit`.
Neither **index** nor **working directory** are changed.

<br>

## git commit
The text up to the **first blank line** in a **commit message** is treated as the **commit title** (aka **subject**).<br>

Also it is possible to **separate** **title** from **description**:
`git commit -m "I am title." -m "I am description."`

Example:
```bash
git log -1
commit cdb7c8f7c04cbfbb9f484745e7bdb04a9bcd9a98 (HEAD -> master)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Mon Jun 2 17:04:27 2025 +0300

    I am title.

    I am description.
```

<br>

## git commit --amend
`git commit --amend` is equal to following command sequence:
1. `git reset --soft %last_commit%`.
2. Perform some changes.
3. `git add`.
4. `git commit`.

<br>

# git restore
`git restore [--source=<tree>] [--staged] [--worktree] [--] <path_to_file>` restores modified file `<path_to_file>`.

<br>

- `-s <tree>`, `--source=<tree>`
Restore the working tree files with the content from the given **source tree**.<br>
It is common to specify the **source tree** by naming a **commit**, **branch** or **tag** associated with it.<br>
If not specified, the contents are restored from `HEAD` if --staged is given, otherwise from the index.<br>

<br>

- `--worktree`, `--staged`
Specify the **restore location**.<br>
If neither option is specified, **by default** the **working tree** is restored.<br>
Specifying `--staged` will only restore the **index**.<br>
Specifying both restores both.

<br>

# git revert
The `git revert ref` create **new commit** that **inverts the changes** introduced by the `ref` and appends a **new commit** with the resulting **inverse content**.

<br>

# git clean
`git clean` **removes untracked** files from working directory.<br>

Flags:
- `-x` means **ignored files** are also **removed** as well as files **unknown** to git.
- `-d` means **remove** **untracked directories** in addition to untracked files.
- `--dry-run` perform **dry run**: don’t actually remove anything, just show what would be done.

<br>

## Examples
- `git clean  -d  -f .`
- `git clean  -d  -fx .`

<br>

# git tag
**Tag** is `ref` that points to **specific commit** in Git history.<br>
There are 2 types of tags:
- **annotated tags** are crated by `git tag -a v1 <commit>`;
- **lightweight tags** are created by `git tag v1 <commit>`;

<br>

**Annotated tags** are stored as **special objects** in the Git database.

<br>

# git describe
`git describe ref` finds the **most recent tag** that is reachable from a commit `ref`.<br>
If **commit** is omitted then `HEAD` is used.<br>
By default `git describe` only shows **annotated tags**.<br>

Format of output: `<tag>_<N>_g<hash>`:
- `<tag>` - tag;
- `<N>` - the number of commits since tag `<tag>` until `ref`;
- `g<hash>` - hash of `<tag>`.
