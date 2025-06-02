# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [git fetch](#git-fetch)
  * [git fetch origin src:dst](#git-fetch-origin-srcdst)
  * [git fetch origin src](#git-fetch-origin-src)
  * [git fetch origin](#git-fetch-origin)
  * [git fetch](#git-fetch-1)
* [Other useful options](#other-useful-options)
<!-- TOC -->

<br>

# git fetch
`git fetch` downloads **objects** and **refs** from another repository.

<br>

## git fetch origin src:dst
1. Reads `remote.origin.url` to determine **URL** of *remote repo* `origin`.
2. Fetches **all refs** that are fit to pattern `src`.
3. Creates/updates appropriate **remote branches** and **local branches** that are fit `dst`.

<br>

## git fetch origin src
1. Reads `remote.origin.url` to determine **URL** of *remote repo* `origin`.
2. Takes `dst` from `remote.origin.fetch`.
3. Fetches **all refs** that are fit to pattern `src`.
4. Creates/updates appropriate **remote branches** and **local branches** that are fit `dst`.

<br>

## git fetch origin
1. Reads `remote.origin.url` to determine **URL** of *remote repo* `origin`.
2. Reads `remote.origin.fetch` to determine **refspecs**.
3. Fetches **all refs** that are fit to pattern `src`.
4. Creates/updates appropriate **remote branches** and **local branches** that are fit `dst`.

<br>

## git fetch
1. Reads `branch.<CURR_BRANCH>.remote`, if **not set** uses **origin**.
2. Reads `remote.origin.url` to determine **URL** of *remote repo* `origin`.
3. Reads `remote.origin.fetch` to determine **refspecs**.
4. Fetches **all refs** that are fit to pattern `src`.
5. Creates/updates appropriate **remote branches** and **local branches** that are fit `dst`.

<br>

# Other useful options
- `--all`: the command `git fetch --all` is **equal** to `git remote update`.
- `--dry-run` show what would be done, **without** making any changes.
- `-p` or `--prune`:
  1. removes all **remote branches** for wich **upstream branches** **don't** exists anymore;
  2. then perform **fetching** as usual;

<br>

> **Note**:<br>
> To perform **only prune** *without fetching* for remote `<repo>` run `git remote prune <repo>` or `git remote prune --dry-run <repo>`.
