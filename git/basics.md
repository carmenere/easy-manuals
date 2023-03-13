# `git config`
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

# `git rebase`
Steps:
1. `git checkout <SRC>` makes `<SRC>` current branch.
2. `git rebase <DST>` performs rebase the current branch `<SRC>` on the branch `<DST>`.

<br>

# `git merge` 
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

A *fast-forward merge* is **not possible** if the branches have **diverged**, in such situation `git` uses **3-way merge**.<br>

`--no-ff` causes `git merge` to generate a merge commit even if it was a fast-forward merge.

<br>

# `git reset`
## `git reset --hard ref`
`git reset --hard ref` resets **entire repository** to the commit `ref`:
1. Move **current branch** (`HEAD`) to the `ref`. Actually this step cancels `git commit`.
2. Updates **index** by content of last commit in **current branch** (**current branch** here is point to `ref`). Actually this step cancels `git add` and `git commit`.
3. Updates **working directory** by content of last commit in **current branch** and **deletes** all **untracked files**. Actually this step cancels `git add`, `git commit` and changes in **working directory**.

<br>

## `git reset --mixed ref`
This mode is used **by default**.<br>
`git reset --mixed ref` stops after **step 2**. Actually this step cancels `git add` and `git commit`.

<br>

## `git reset --soft ref`
`git reset --soft ref` stops after **step 1**. Actually this step cancels `git commit`.
Neither **index** nor **working directory** are changed.

<br>

## `git commit --amend`
`git commit --amend` is equal to following command sequence:
1. `git reset --soft %last_commit%`.
2. Perform some changes.
3. `git add`.
4. `git commit`.
   
<br

# `git revert`
The `git revert ref` create **new commit** that **inverts the changes** introduced by the `ref` and appends a **new commit** with the resulting **inverse content**.

<br>

# `git clean`
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

# `git tag`
**Tag** is `ref` that point to **specific commit** in Git history.<br>
There are 2 types of tags:
- **annotated tags** are crated by `git tag -a v1 <commit>`;
- **lightweight tags** are created by `git tag v1 <commit>`;

<br>

**Annotated tags** are stored as **special objects** in the Git database.

<br>

## `git describe`
`git describe ref` finds the **most recent tag** that is reachable from a commit `ref`.<br>
If **commit** is omitted then `HEAD` is used.<br>
By default `git describe` only shows **annotated tags**.<br>

Format of output: `<tag>_<N>_g<hash>`:
- `<tag>` - tag;
- `<N>` - the number of commits since tag `<tag>` until `ref`;
- `g<hash>` - hash of `<tag>`.

<br>

# `git init`
`master` or `main` are the default names for a **initial branch** when you run `git init`.<br>

<br>

# `git clone`
`origin` is the **default name** for a **remote repository** when you run `git clone`.<br>

`git clone -o foo <URI>` then name `foo` will be used instead `origin`.<br>
`git clone --recurse-submodules URI` performs clone with **submodules**.<br>

<br>

# Branches
## Upstream branch
**Upstream branch** – any branch in `.git/refs/heads` of **remote** repository.<br>

<br>

## Remote branch
Git stores all branches (**local** and **remotes**) inside `.git/refs` directory:
- `.git/refs/heads` - **local branches**;
- `.git/refs/remotes` – **remote branches**.

<br>

**Remote branch** – mirror copy of **upstream branch** that is stored in `.git/refs/remotes` of **local** repository.<br>
**Name** of *remote branch* has following format: `<repo>/<branch>`.<br>
**Remote branches** are updated **automatically** every time git syncs with remote repo if appropriate **upstream branches** contain new commits.<br>

> **Notes**:<br>
> **Remote branches** are **read only**.<br>
> `git checkout` to **remote branch** performs **HEAD detaching**.

<br>

## Tracking branch
**Tracking branch** – **local branch** which is *connected* to **remote branch**.

<br>

## Ways to make *local branch* **tracking branch**
### `git checkout`
1. `git checkout -b baz` creates **new local branch** `baz` from **current branch**.
2. `git checkout -b foo --track origin/bar` creates **new local branch** `foo` from `origin/bar` and **set** it **to track** the **remote branch** `bar`, `foo` is a **tracking branch**.
    - option `--track` is used **by default**.
3. `git checkout -b foo --no-track origin/bar` creates **new local branch** `foo` from `origin/bar` and **doesn't** set it to track the **remote branch** `bar`.

> **Notes**:<br>
> if **omit** `-b new_branch` then `git checkout origin/bar` will use name of *remote branch* `bar` as name for **new** *local branch*.<br>
> if **omit** `-b new_branch` and `origin/` prefix then `git checkout bar` will try find `bar` in `refs/remotes/repo` and if it doesn't exist - returns error.<br>
> `git checkout bar` is equal to `git checkout -b bar --track origin/bar`.<br>
> `git checkout -b foo origin/bar` is equal to  `git checkout -b foo --track origin/bar`.<br>

<br>

### `git push`
- `git push -u <repo> branch`
- `git push --set-upstream <repo> branch`

<br>

### `git branch`
`git branch` sets **current branch** **to track** the **remote branch** `bar`:
- `git branch -u <repo>/bar`
- `git branch --set-upstream-to=<repo>/bar`

<br>

`--unset-upstream` disables tracking.

<br>

# `git diff`
`git diff` shows changes between the **working tree** and the **index** by default.<br>
`git diff --cached ref` shows changes between the **index** and **commit** `ref`, if `ref` is **omitted** `HEAD` is used.<br>
`git diff ref1 ref2 -- <path>` shows **diff** between `ref1` and `ref2` for specific file `<path>`.
