# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [git rebase](#git-rebase)
* [Example](#example)
  * [git status](#git-status)
  * [Create new file](#create-new-file)
  * [Commit `a.txt`](#commit-atxt)
    * [git log](#git-log)
  * [Create new branch `feat-1`](#create-new-branch-feat-1)
  * [Create new file `feat.txt`](#create-new-file-feattxt-)
  * [Commit `feat.txt`](#commit-feattxt)
    * [git log](#git-log-1)
  * [Then create another file `b.txt` in `main` branch](#then-create-another-file-btxt-in-main-branch)
  * [Commit `b.txt`](#commit-btxt)
    * [git log](#git-log-2)
  * [**Rebase**](#rebase)
    * [git checkout feat-1](#git-checkout-feat-1)
    * [git rebase main](#git-rebase-main)
  * [Compare commits **before** rebase and **after** rebase](#compare-commits-before-rebase-and-after-rebase)
    * [In branch `main`](#in-branch-main)
      * [git checkout main](#git-checkout-main)
      * [git log](#git-log-3)
    * [In branch `feat-1`](#in-branch-feat-1)
      * [git checkout feat-1](#git-checkout-feat-1-1)
      * [git log](#git-log-4)
  * [Remove dangling commits:](#remove-dangling-commits-)
  * [Try git checkout b9001a33 again](#try-git-checkout-b9001a33-again)
* [git rebase --onto](#git-rebase---onto)
<!-- TOC -->

<br>

# git rebase
Steps:
1. `git checkout feature` makes `feature` **current** branch.
2. `git rebase main` performs rebase the **current** branch `feature` on the branch `main`, rewriting commits only in **current** `feature` branch.

<br>

Another syntax:
`git rebase main feature`, here **git** first performs an automatic `git checkout feature` before rebasing `feature` to `main`.<br>
After rebasing you automatically are in `feature` branch.

<br>

# Example
## git status
```bash
/tmp/abc [main] % git status
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

## Create new file
```bash
/tmp/abc [main] % vi a.txt

/tmp/abc [main] % git status
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	a.txt

nothing added to commit but untracked files present (use "git add" to track)
```

## Commit `a.txt`
```bash
/tmp/abc [main] % git add .

/tmp/abc [main] % git commit -m "a.txt"
[main (root-commit) 351693b] a.txt
 1 file changed, 3 insertions(+)
 create mode 100644 a.txt
```

### git log
```bash
/tmp/abc [main] % git log
commit 351693b656b394650dc5a027f6acdb96a82f8e9e (HEAD -> main)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:45:26 2023 +0300

    a.txt

/tmp/abc [main] % git status
On branch main
nothing to commit, working tree clean
```

<br>

## Create new branch `feat-1`
```bash
/tmp/abc [main] % git checkout -b feat-1
Switched to a new branch 'feat-1'
```

## Create new file `feat.txt` 
```bash
/tmp/abc [feat-1] % vi feat.txt
```

## Commit `feat.txt`
```bash
/tmp/abc [feat-1] % git add .
/tmp/abc [feat-1] % git commit -m "feat.txt"
[feat-1 b9001a3] feat.txt
 1 file changed, 2 insertions(+)
 create mode 100644 feat.txt
```

### git log
```bash
/tmp/abc [feat-1] % git log
commit b9001a33a86b6b70c0e4179cd1a8e432d4da2e00 (HEAD -> feat-1)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:47:34 2023 +0300

    feat.txt

commit 351693b656b394650dc5a027f6acdb96a82f8e9e
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:45:26 2023 +0300

    a.txt
```

<br>

## Then create another file `b.txt` in `main` branch
```bash
/tmp/abc [feat-1] % git checkout main
Switched to branch 'main'

/tmp/abc [main] % vi b.txt
```

<br>

## Commit `b.txt`
```bash
/tmp/abc [main] % git add .
/tmp/abc [main] % git commit -m "b.txt"
[main 4d9214a] b.txt
 1 file changed, 3 insertions(+)
 create mode 100644 b.txt
```

### git log
```bash
/tmp/abc [main] % git log
commit 4d9214afed0b5d3fa887a80ccd86574702cac1d4 (HEAD -> main)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:48:04 2023 +0300

    b.txt

commit 351693b656b394650dc5a027f6acdb96a82f8e9e
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:45:26 2023 +0300

    a.txt
```

<br>

## **Rebase**
### git checkout feat-1
```bash
/tmp/abc [main] % git checkout feat-1
Switched to branch 'feat-1'
```

### git rebase main
```bash
/tmp/abc [feat-1] % git rebase main
Successfully rebased and updated refs/heads/feat-1.
```

<br>

## Compare commits **before** rebase and **after** rebase
### In branch `main`
#### git checkout main
```bash
/tmp/abc [feat-1] % git checkout main
Switched to branch 'main'
```

#### git log
```bash
/tmp/abc [main] % git log
commit 4d9214afed0b5d3fa887a80ccd86574702cac1d4 (HEAD -> main)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:48:04 2023 +0300

    b.txt

commit 351693b656b394650dc5a027f6acdb96a82f8e9e
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:45:26 2023 +0300

    a.txt
```

**All commits are unchanged**.

<br>

### In branch `feat-1`
#### git checkout feat-1
```bash
/tmp/abc [main] % git checkout feat-1
Switched to branch 'feat-1'
```

#### git log
```bash
/tmp/abc [feat-1] % git log
commit 89139e3124ebc8e09b5a33ad1c3c269c4f6a3583 (HEAD -> feat-1)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:47:34 2023 +0300

    feat.txt

commit 4d9214afed0b5d3fa887a80ccd86574702cac1d4 (main)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:48:04 2023 +0300

    b.txt

commit 351693b656b394650dc5a027f6acdb96a82f8e9e
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:45:26 2023 +0300

    a.txt
```

<br>

Commit `feat.txt` **changed**: `b9001a33a86b6b70c0e4179cd1a8e432d4da2e00` -> `89139e3124ebc8e09b5a33ad1c3c269c4f6a3583`.<br>

Also old commit `b9001a33a86b6b70c0e4179cd1a8e432d4da2e00` **still exists**:
```bash
/tmp/abc [feat-1] % git checkout b9001a33a86b6b70c0e4179cd1a8e432d4da2e00
Note: switching to 'b9001a33a86b6b70c0e4179cd1a8e432d4da2e00'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at b9001a3 feat.txt

/tmp/abc [] % git log
commit b9001a33a86b6b70c0e4179cd1a8e432d4da2e00 (HEAD)
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:47:34 2023 +0300

    feat.txt

commit 351693b656b394650dc5a027f6acdb96a82f8e9e
Author: Anton Romanov <a.romanovich86@gmail.com>
Date:   Fri Sep 15 08:45:26 2023 +0300

    a.txt
```

<br>

## Remove dangling commits: 
```bash
/tmp/abc [main] % git reflog expire --expire-unreachable=now --all

/tmp/abc [main] % git gc --prune=all --aggressive
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 10 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (9/9), done.
Total 9 (delta 1), reused 0 (delta 0), pack-reused 0
```

## Try git checkout b9001a33 again
```bash
/tmp/abc [main] % git checkout b9001a33a86b6b70c0e4179cd1a8e432d4da2e00
fatal: reference is not a tree: b9001a33a86b6b70c0e4179cd1a8e432d4da2e00

/tmp/abc [main] %
```

<br>

# git rebase --onto
Syntax: `git rebase [--onto <new base>] [<upstream> [<branch>]]`.<br>

Consider example:
```bash
A <- B <- C <- D                     main
                \
                 E <- F <- G         wrong_branch
                            \
                             H <- I  other_branch
```

`other_branch` is based on `wrong_branch`.<br>
We want to rebase `other_branch` to `main` so that the commits of `wrong_branch` are **not included** in its commits.<br>
In other words, we want to achieve this:
```bash
A <- B <- C <- D                main
               |\
               | \
               |  E <- F <- G   wrong_branch
                \
                 H' <- I'       other_branch
```

<br>

The git command to do this is:
```bash
git rebase --onto main wrong_branch other_branch
```

or, if you’re already in `other_branch`, just:
```bash
git rebase --onto main wrong_branch
```

<br>

`main` becomes the **new base** for branch `other_branch` which was previously based on `wrong_branch` (aka **upstream**).