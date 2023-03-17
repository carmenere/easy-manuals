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
