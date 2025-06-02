# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [git push](#git-push)
* [Force push](#force-push)
  * [`--force`](#--force)
  * [`--force-with-lease`](#--force-with-lease)
* [Variants](#variants)
  * [git push origin src:dst](#git-push-origin-srcdst)
  * [git push origin src](#git-push-origin-src)
  * [git push origin](#git-push-origin)
  * [git push](#git-push-1)
  * [git push origin HEAD](#git-push-origin-head)
  * [git push origin :dst](#git-push-origin-dst)
<!-- TOC -->

<br>

# git push
`git push` uploads content from a **local** repository to a **remote** repository.<br>

`git push` assumes that **upstream** branch can **only** be **fast-forwarded** by **remote branch**. So, `git push` **fails** when **upstream** branch can **not** be **fast-forwarded** by **remote branch**.<br>
So, if the **upstream** branch has **diverged** from **remote** branch, you need to perform `git pull` and *merge* **remote** branch into **local** one, then try `git push` again.<br>

<br>

# Force push
## `--force`
`git push <remote> --force` or `git push --force` **force** the **push** even if **upstream** branch can **not** be **fast-forwarded** by **remote branch**.<br>

If somebody else built on top of your original history while you are rebasing, the tip of the branch at the remote may advance with their commit, and blindly pushing with `--force` will **lose** their work.<br>

<br>

## `--force-with-lease`
Git provides **safer** option `--force-with-lease`.<br>
`git push --force-with-lease` will **not** overwrite any work in **remote** repo if some commits were added to the **upstream** branch by someone else. It ensures you do **not** overwrite someone elses work by **force pushing**.<br>

<br>

# Variants
## git push origin src:dst
1. Reads `remote.origin.url` to determine **URL** of *remote repo* `origin`.
2. If `dst` doesn't exist in *remote repo* `origin` git will create it, but *local branch* `src` will not become *tracking branch*.
3. `git push origin --set-upstream src:dst` will also make *local branch* `src` *tracking branch*.

<br>

## git push origin src
1. Refspec `src` equal to `src:src`, so, here `dst` = `src`.

<br>

## git push origin
1. Git resolves **refspec** using following algorithm:
   - reads `remote.repo.push`;
     - if **not set** then reads both `branch.<CURR_BRANCH>.merge` and `push.default`;
       - if `push.default` is **not set** - uses **simple**.


<br>

## git push
1. Git resolves name of **repo** using following algorithm:
   - `branch.<CURR_BRANCH>.pushRemote` -> `remote.pushDefault` -> `branch.<CURR_BRANCH>.remote` -> **origin**, i.e.:
     - reads `branch.<CURR_BRANCH>.pushRemote` at first;
       - if **not set** then reads `remote.pushDefault`;
       - if **not set** then reads `branch.<CURR_BRANCH>.remote`;
       - if **not set** then uses *default* repo **origin**.
2. Reads `remote.origin.url` to determine **URL** of *remote repo* `origin`.

<br>


## git push origin HEAD
This is the same as `git push origin $(git branch --show-current)`.

<br>

## git push origin :dst
This causes `git push` to delete **upstream branch** `dst` and **remote branch** `refs/remotes/repo/dst`.

<br>

> **Note**:<br>
> `git push origin :dst` is **equal** to `git push repo --delete dst`.
