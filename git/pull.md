# git pull
`git pull` incorporates changes from a **remote repo** into the **current branch**.<br>
Under the hood the `git pull origin src:dst` runs `git fetch` with the given parameters and then calls either `git rebase` or `git merge`:
1. `git fetch origin src:dst`;
2. `git merge refs/remotes/origin/src`;

<br>

> **Notes**:<br>
> `git pull` **doesn't** support **globbing refspec**.
> if more than one **refspec** was passed then `git pull` will merge **all remote branches** into **current branch** and create **octopus merge**.
> if refscpec **wasn't** passed and `branch.<CURR_BRANCH>.merge` **isn't** set `git pull` *exits* with **error**.

<br>

## git pull
1. Reads `branch.<CURR_BRANCH>.remote`, if **not set** uses **origin**.
2. Reads `remote.<repo>.fetch` to determine **refspecs** for `git fetch`.
3. Reads `branch.<CURR_BRANCH>.merge` to detremine which **remote branch** (`refs/remotes/<repo_name>/<name>`) to merge into **current branch** (`<CURR_BRANCH>`).

<br>

## git pull --ff-only
`git pull --ff-only` performs merge only if **fast-forward** is possible.<br>
If current branch and remote branch were diverged and **fast-forward** is **not possible** `git pull --ff-only` *exits* with **error**.

<br>

To set `--ff-only` behaviour by default for `git pull` run:
`git config --local pull.ff only`
