# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [Branches](#branches)
  * [Upstream branch](#upstream-branch)
  * [Remote branch](#remote-branch)
  * [Tracking branch](#tracking-branch)
    * [Tracking branch](#tracking-branch-1)
  * [Ways to make *local branch* **tracking branch**](#ways-to-make-local-branch-tracking-branch)
    * [git checkout](#git-checkout)
    * [`git checkout` error](#git-checkout-error)
    * [git push](#git-push)
    * [git branch](#git-branch)
  * [Unset tracking](#unset-tracking)
<!-- TOC -->

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

<br>

> **Notes**:<br>
> **Remote branches** are **read only**.<br>
> `git checkout` to **remote branch** performs **HEAD detaching**.

<br>

## Tracking branch
**Tracking branch** – **local branch** which is *connected* to **remote branch**.

<br>

### Tracking branch
Consider config:
```sh
[branch "foo"]
    remote = origin
    merge = refs/heads/bar
```

<br>

> **Here**:<br>
> `refs/heads/bar` - **upstream branch**.<br>
> `refs/remotes/origin/bar` - **remote branch**.<br>
> `refs/heads/foo` - **local branch** and **tracking branch**.<br>

<br>

## Ways to make *local branch* **tracking branch**
### git checkout
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

### `git checkout` error
**Command**:
```bash
git checkout foo
```

**Output**:
```bash
error: The following untracked working tree files would be overwritten by checkout
 ...
Please move or remove them before you can switch branches.
Aborting
```

<br>

This is caused by following, suppose you have some file in **tag** `1.3.1`, e.g., `migrations/INIT.sql`, but in tag `1.0.0` you have not this file.<br>
If you *checkout* to tag `1.0.0` and create there file `migrations/INIT.sql` even with the same content `git` **rejects** your attempt to *checkout* into tag `1.3.1`.<br>
If you provide `-f` option then `git checkout -f` will *checkout* and overwrites file `migrations/INIT.sql` from tag `1.3.1`.<br>

Also you can call `git clean` to **explicitly clear workdir** before `git checkout`.

<br>

### git push
- `git push -u <repo> branch`
- `git push --set-upstream <repo> branch`

<br>

### git branch
Set **current branch** to **track** the **remote branch** `refs/remotes/<repo>/foo`:
- `git branch -u <repo>/foo`
- `git branch --set-upstream-to=<repo>/foo`

<br>

Set particular branch `bar` to **track** the **remote branch** `refs/remotes/<repo>/foo`:
- `git branch --set-upstream-to=origin/foo bar`

<br>

## Unset tracking
- `git branch --unset-upstream` **disables tracking** for **current branch**.

<br>