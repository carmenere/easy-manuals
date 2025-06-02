# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [Refs](#refs)
  * [](#)
* [Branches](#branches)
  * [Branch forcing](#branch-forcing)
  * [HEAD](#head)
  * [Dangling commits](#dangling-commits)
* [Refspecs](#refspecs)
  * [Refspecs and Git config file](#refspecs-and-git-config-file)
* [Config options](#config-options)
    * [`git` without `refspec`](#git-without-refspec)
    * [`git` without `repo`](#git-without-repo)
<!-- TOC -->

<br>

# Refs
So, there are 3 ways to refer to commits in Git:
- by **full** SHA-1 **hash** of *commit*;
- by **partial** SHA-1 **hash** of *commit*;
- by **ref**.

<br>

A **ref** (**Git reference**) is a **name** of *text file* that *contains* a **full hash** of commit, i.e., **ref** is a **user-friendly alias** for a **commit hash**.<br>
**All refs** are stored in the `.git/refs`.<br>

<br>

`.git/refs` consists of 3 subdirectories:
- `heads` for **local branches**;
- `remotes` for **remote branches**, it contains **separate subdir** for every **remote repo** and **at least** it has `origin` subdir;
- `tags` for **tags**.

## 


<br>

When passing to a Git command:
- **full name** of the ref:
  - `refs/heads/foo`
  - `refs/remotes/origin/foo`
- **short name** of the ref:
  - `remotes/origin/foo`
  - `origin/foo`
  - `foo`

<br>

# Branches
A **branch** is a *ref* that is **moved automatically by Git** when you make a *commit to a branch*.<br>

<br>

## Branch forcing
**Branch forcing** – binding branch to particular commit.<br>

`git branch -f master ref` binds branch `master` to `ref`.<br>

<br>

## HEAD
`HEAD` is a **special ref** that points to the name of the **current branch**: **HEAD -> Branch -> Commit**.<br>
Show **current branch**: `git branch --show-current`.<br>
**Detached** `HEAD` is a **special state** when `HEAD` points **directly** to some commit in the history.<br>

<br>

## Dangling commits
Consider example:
                     C5
                       \
main ----> C2 -> C1 -> C0
                      /
feature ---> C3 -> C4

<br>

Here **C5** is **Dangling commit**.<br>
**Dangling commit** is a commit that doesn’t have any *branch* or *another commit* referenced to it.<br>

<br>

# Refspecs
**Refspec** is **mapping** between **remote refs** and **local refs**.<br>
**Refspec** define behaviour for `git fetch` and `git push` commands.<br>

<br>

The format of a `refspec` is `[+]<src>:<dst>`:
- `+` is **optional** and means that `git` will update **refs** even **fast-forward** is **not possible**, i.e., forces **non-fast-forward**.
- `<src>` and `<dst>` define **refs** and depend on the context:
  - for `git fetch`:
    - `<remote_refs>:<local_refs>`
  - for `git push`:
    - `<local_refs>:<remote_refs>`

<br>

**Globbing refspec** is a **refspec** with `*`, e.g., `refs/heads/*:refs/remotes/origin/*`.<br>
In case of `git fetch` the `+refs/heads/*:refs/remotes/origin/*` means that Git fetches all the **refs** under `refs/heads` from **remote repo** and writes them to `refs/remotes/origin` locally.<br>

<br>

> **Note**:<br>
> In **refspec** `<src>` defines pattern for **ref** and `<dst>` defines **new name** for **ref**: **ref** that was captured by `<src>` will be renamed to `<dst>`.<br>
> In **globbing refspec** `*` in `<src>` means all **refs** and `*` in `<dst>` will be replaced by names which were captured by `<src>`.

<br>

## Refspecs and Git config file
The command `git clone URI ` creates config file `.git/config` and sets `remote.origin.fetch` to *default* value `+refs/heads/*:refs/remotes/origin/*`:
```sh
[remote "origin"]
    url = https://github.com/example
    fetch = +refs/heads/*:refs/remotes/origin/*
```

The `remote.<name>.fetch` maps **upstream branches** (`refs/heads/*`) to **remote branches** (`refs/remotes/origin/*`).

<br>

You can also specify **multiple refspecs** *for fetching* in your config file:
```sh
[remote "origin"]
    url = https://github.com/example
    fetch = +refs/heads/master:refs/remotes/origin/master
    fetch = +refs/heads/experiment:refs/remotes/origin/experiment
```

<br>

You can also add **refspecs** *for push* in your config file:
```sh
[remote "origin"]
    url = https://github.com/example
    fetch = +refs/heads/*:refs/remotes/origin/*
    push = refs/heads/master:refs/heads/qa/master
```

<br>

# Config options
Consider config:
```sh
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
    ignorecase = true
    precomposeunicode = true
[remote "origin"]
    url = git@github.com:softwarebaker/easy-manuals.git
    fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
    remote = origin
    merge = refs/heads/main
[branch "EM-46"]
    remote = origin
    merge = refs/heads/EM-46
    pushRemote = abc
[push]
    default = matching
[remote]
    pushDefault = abc
```

<br>

When `git` run without **remote repo** and **refspec** it will use following options from *config file*:
|Option|Description|
|:-----|:----------|
|`remote.<name>.url`|The URL of a **remote repo**.|
|`remote.<name>.fetch`|The default **refspecs** for `git fetch`.|
|`remote.<name>.push`|The default **refspecs** for `git push`.|
|`push.default`|Defines the action `git push` should take if **no refspec** is given (whether from the cli, config, or elsewhere).|
|`branch.<name>.remote`|When branch `<name>` is **current branch** it tells `git fetch` and `git push` which **remote repo** to use if it was not supplied.|
|`branch.<name>.pushRemote`|If set it overrides `remote.pushDefault` for `git push`.|
|`remote.pushDefault`|If set it overrides `branch.<name>.remote` for `git push` for **all branches**.|
|`branch.<name>.merge`|Defines, together with `branch.<name>.remote`, the **upstream branch** for **local branch** `<name>`, i.e., it makes branch `<name>` **tracking branch**.|

<br>

Possible values for `push.default`:
- `nothing` - **don't push anything** unless a refspec is given. This is primarily meant for people who want to avoid mistakes by always being explicit.
- `current` - push the **current branch** to update a branch with the same name on the receiving end. Works in both central and non-central workflows.
- `upstream` - push the **current branch** back to the branch whose changes are usually integrated into the **current branch** (which is called @{upstream}). This mode only makes sense if you are pushing to the same repository you would normally pull from (i.e. central workflow).
- `simple` - (**default** value) pushes the **current branch** with the same name on the remote..
- `matching` - push **all branches** having the same name on both ends.

<br>

### `git` without `refspec`
When `git` is run without `refspec`:
- `remote.<name>.fetch` is used by `git fetch`;
- `remote.<name>.push` is used by `git push`;

<br>

### `git` without `repo`
When `git` is run without `repo`:
- Steps to determine **repo** to use for `git push`:
  - `branch.<CURR_BRANCH>.pushRemote` -> `remote.pushDefault` -> `branch.<CURR_BRANCH>.remote` -> **origin**
- Steps to determine **repo** to use for `git fetch`:
  - `branch.<CURR_BRANCH>.remote` -> **origin**

<br>
