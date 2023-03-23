# git push
`git push` updates remote refs using local refs

<br>

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



<br>

## git push origin HEAD
This is the same as `git push origin $(git branch --show-current)`.

<br>

## git push origin :dst
This causes `git push` to delete **upstream branch** `dst` and **remote branch** `refs/remotes/repo/dst`.

<br>

> **Note**:<br>
> `git push origin :dst` is **equal** to `git push repo --delete dst`.
