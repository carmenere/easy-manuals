# git remote
`git remote` manages set of **remote repos** (**remotes**) whose branches are tracked.<br>

|Command|Description|
|:------|:----------|
|`git remote`|Lists all remotes.|
|`git remote -v`|Lists all remotes and URL for each remote.|
|`git remote show <repo>`|Shows detailed info about remote `<repo>`.|
|`git remote add <repo> <url>`|Adds new remote `<repo>` with URL `<url>`.|
|`git remote remove <repo>`|Deletes remote `<repo>`.|
|`git remote rename <old-name> <new-name>`|Renames remote `<old-name>` to `<new-name>`.|
|`git remote get-url <repo>`|Shows URL for remote `<repo>`.|
|`git remote set-url <repo> <newurl>`|Changes URL to `<newurl>` for remote `<repo>`.|
|`git remote prune <repo>`|Removes all **remote branches** for wich **upstream branches** don't exists anymore.|

<br>

# Remotes URLs
Git supports many protocols to access a **remote repo**.<br>

Examples:
- **HTTP** is an easy way to allow **anonymous**, **read-only** *access* to a repository.
- For **read-write** *access*, you should use **SSH** instead.
