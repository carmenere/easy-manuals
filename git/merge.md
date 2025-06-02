# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [git merge](#git-merge)
  * [Kinds of merge](#kinds-of-merge)
  * [Merge base](#merge-base)
    * [git merge --no-ff <branch>](#git-merge---no-ff-branch)
* [Example: merge one branch `SRC_BRANCH` into branch `DST_BRANCH`](#example-merge-one-branch-src_branch-into-branch-dst_branch)
  * [Prerequisites](#prerequisites)
  * [Update all remote branches](#update-all-remote-branches)
  * [Checkout to `LOCAL_DST_BRANCH`](#checkout-to-local_dst_branch)
  * [Merge `SRC_BRANCH` into `LOCAL_DST_BRANCH`](#merge-src_branch-into-local_dst_branch)
  * [Push](#push-)
    * [Case 1. Just push](#case-1-just-push)
    * [Case 2. With `push options` for GitLab](#case-2-with-push-options-for-gitlab)
  * [Remove `LOCAL_DST_BRANCH`](#remove-local_dst_branch)
  * [Remove `${LOCAL_DST_BRANCH}`](#remove-local_dst_branch-1)
    * [Delete `local branch` with name ${LOCAL_DST_BRANCH}](#delete-local-branch-with-name-local_dst_branch)
    * [Delete `upstream branch` with name ${LOCAL_DST_BRANCH}](#delete-upstream-branch-with-name-local_dst_branch)
    * [Delete `remote branch` with name ${LOCAL_DST_BRANCH}](#delete-remote-branch-with-name-local_dst_branch)
    * [Delete all stale `remote branches`](#delete-all-stale-remote-branches)
<!-- TOC -->

<br>

# git merge
Steps:
1. `git checkout <DST>` makes `<DST>` **current** branch.
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

## Merge base
The `git merge-base` **finds the best common ancestor(s)** between two commits to use in a three-way merge.<br>
**One** common ancestor (e.g. `A`) is **better** than **another** (e.g. `B`) common ancestor if the `B` is an **ancestor** of the `B`.<br>
A **best common ancestor** is a **common ancestor** that **doesn't** have any *better common ancestor*.<br>


Consider example:<br>
```bash
--C1--C2---C3---
```
Here `C2` is an **ancestor** of the `C3`, so `C3` is **better common ancestor** than `C2`.<br>

A **merge base** is a **best common ancestor** of two or more commits/branches.<br>

For example, with this topology:
```bash
          C6---C7---B
         /
--C1---C2---C3---C4---C5---A
```
the **merge base** between `A` and `B` is `C2`.

<br>

When the history involves **criss-cross merges**, there can be more than one best common ancestor for two commits.<br>

For example, with this topology:
```bash
---1---o---A
    \ /
     X
    / \
---2---o---o---B
```

both `1` and `2` are merge bases of `A` and `B`. **Neither one is better** than the other.<br>
When the `--all` option is **not** given, it is **unspecified** which best one is output.<br>

**Option** `-a` or `--all` outputs **all merge bases for the commits**, instead of just one.<br>
**Option** `--octopus` computes the best common ancestors of **all** supplied commits, in preparation for an **n-way** merge.<br>
Consider topology:
```bash
       o---o---o---o---o
      /                 \
     /   o---o---o---o---M
    /   /
---2---1---o---o---o---A
```

The result of `git merge-base --octopus A B C` is `2`, because `2` is the **best common ancestor** of **all** commits.<br>
**But** the result of `git merge-base A B C` is `1`.<br>
This is because `git merge-base A B C` will compute the merge base between `A` and a **hypothetical** commit `M`: `git merge-base A M`, which is a merge between `B` and `C`.<br>
And the **equivalent topology** with a merge commit `M` between `B` and `C` is:
```bash
       o---o---o---o---o
      /                 \
     /   o---o---o---o---M
    /   /
---2---1---o---o---o---A
```
and the result of `git merge-base A M` is `1`. Commit `2` is also a common ancestor between `A` and `M`, but `1` is a **better** common ancestor, because `2` is an ancestor of `1`.
Hence, `2` is not a merge base.<br>

<br>

### git merge --no-ff <branch>
`--no-ff` causes `git merge` to generate a new **merge commit** even if it was a *fast-forward* merge.<br>

<br>

# Example: merge one branch `SRC_BRANCH` into branch `DST_BRANCH`
## Prerequisites
```bash
SRC_BRANCH=dev_1

DST_BRANCH=some_dst_branch

LOCAL_DST_BRANCH="merge_${SRC_BRANCH}_to_${DST_BRANCH}"
COMMIT_MSG="Merge branch 'origin/${SRC_BRANCH}' into 'origin/${DST_BRANCH}'"

echo SRC_BRANCH=${SRC_BRANCH}
echo DST_BRANCH=${DST_BRANCH}
echo LOCAL_DST_BRANCH=${LOCAL_DST_BRANCH}
echo COMMIT_MSG=${COMMIT_MSG}
```

<br>

## Update all remote branches
```bash
git remote update
```

<br>

## Checkout to `LOCAL_DST_BRANCH`
```bash
git checkout --no-track -b "${LOCAL_DST_BRANCH}" "origin/${DST_BRANCH}"
```

<br>

## Merge `SRC_BRANCH` into `LOCAL_DST_BRANCH`
```bash
git merge -m "${COMMIT_MSG}" "origin/${SRC_BRANCH}"
```

<br>

## Push 
### Case 1. Just push
```bash
git push origin "${LOCAL_DST_BRANCH}":"${LOCAL_DST_BRANCH}"
```

### Case 2. With `push options` for GitLab
```bash
git push origin "${LOCAL_DST_BRANCH}":"${LOCAL_DST_BRANCH}" \
    -o merge_request.create \
    -o merge_request.target=${DST_BRANCH} \
    -o merge_request.title="SYNC: ${SRC_BRANCH} => ${DST_BRANCH}" \
    -o merge_request.remove_source_branch \
    -o merge_request.merge_when_pipeline_succeeds
```

<br>

## Remove `LOCAL_DST_BRANCH`
## Remove `${LOCAL_DST_BRANCH}`
### Delete `local branch` with name ${LOCAL_DST_BRANCH}
```bash
git branch -D "${LOCAL_DST_BRANCH}"
```

### Delete `upstream branch` with name ${LOCAL_DST_BRANCH}
```bash
git push origin --delete "${LOCAL_DST_BRANCH}"
```

### Delete `remote branch` with name ${LOCAL_DST_BRANCH}
```bash
git branch --delete --remotes origin/"${LOCAL_DST_BRANCH}"
```

### Delete all stale `remote branches`
```bash
git fetch --all --prune
```
