# git rev-list
`git rev-list` lists objects in reverse chronological order:
- `git rev-list --objects --all` - lists all objects (**blobs**, **trees**, **tags**, **commits**) in reverse chronological order.
- `git rev-list --all` - lists all objects (**blobs**, **trees**, **tags**, **commits**) in reverse chronological order.

<br>

Command `git cat-file --batch-check='%(objectname) %(objecttype) %(rest)'` shows **type of object** and can be used in combination with `git rev-list`:
```sh
git rev-list --objects --all | git cat-file --batch-check='%(objectname) %(objecttype) %(rest)'
```

<br>

## Find dangling commits:
1. `git branch --contains <commit>` returns list of **all branches** that **contain commit** `<commit>`.

Example:
```sh
git rev-list --all | while read COMMIT; do echo "$COMMIT: $(git branch --contains $COMMIT)"; done
```

<br>

## Remove dangling commits:
```sh
git fetch -p
git reflog expire --expire-unreachable=now --all
git gc --prune=all --aggressive
```

<br>

# git show 
`git show` shows content of **objects**: **blobs**, **trees**, **tags**, **commits**.

<br>

# git-ls-remote
`git-ls-remote` lists **refs** in a **remote repository**:
- `git ls-remote --tags origin`
- `git ls-remote --heads origin`

<br>

# git show-ref
`git show-ref` lists **refs** in a **local repository**:
- `git show-ref --head`
- `git show-ref --tags`
