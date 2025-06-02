# Add new submodule
To add new submodule there is command: `git submodule add`.<br>

```bash
git submodule add git@github.com:carmenere/dtools-core.git core
```

<br>

# Delete submodule
To remove a submodule you need to:
1. Delete the relevant section from the `.gitmodules` file.
2. Stage the `.gitmodules` changes: `git add .gitmodules`.
3. Delete the relevant section from `.git/config` file.
4. Remove the submodule files from the index: `git rm --cached path_to_submodule`.
5. Remove the submodule's `.git` directory: `rm -rf .git/modules/path_to_submodule`.
6. Commit the changes: `git commit -m "Removed submodule <name>"`.
7. Delete the now untracked submodule files: `rm -rf path_to_submodule`.

<br>
