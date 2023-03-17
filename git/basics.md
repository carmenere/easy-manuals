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

# git rebase
Steps:
1. `git checkout <SRC>` makes `<SRC>` current branch.
2. `git rebase <DST>` performs rebase the current branch `<SRC>` on the branch `<DST>`.

<br>

# git merge
Steps:
1. `git checkout <DST>` makes `<DST>` current branch.
2. `git merge <SRC>` performs merge the branch `<SRC>` with the branch `<DST>`.

<br>

> **Note**:<br>
> `git merge --continue` **continue** merge process after all conflicts were **resolved**.<br>
> `git merge --abort` **abort** the current conflict resolution process.<br>

<br>

## Kinds of merge
There are two main ways Git will merge:
- **fast forward merge**
- **3-way merge**

<br>

A **fast-forward merge** can occur when there is a **linear path** from the last commit of **current branch** to the last commit of **target branch**.<br>
`git` just moves (**fast forward**) the **current branch** to the **target branch**. It is *like* **branch forcing**.<br>

<br>

A *fast-forward merge* is **not possible** if the branches have **diverged**, in such situation `git` uses **3-way merge**.<br>
**3-way merge** create a **merge commit** - additionak commit to tie together the two histories.<br>

<br>

### git merge --no-ff <branch>
`--no-ff` causes `git merge` to generate a merge commit even if it was a *fast-forward* merge.

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

## git commit --amend
`git commit --amend` is equal to following command sequence:
1. `git reset --soft %last_commit%`.
2. Perform some changes.
3. `git add`.
4. `git commit`.
   
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

## git describe
`git describe ref` finds the **most recent tag** that is reachable from a commit `ref`.<br>
If **commit** is omitted then `HEAD` is used.<br>
By default `git describe` only shows **annotated tags**.<br>

Format of output: `<tag>_<N>_g<hash>`:
- `<tag>` - tag;
- `<N>` - the number of commits since tag `<tag>` until `ref`;
- `g<hash>` - hash of `<tag>`.
