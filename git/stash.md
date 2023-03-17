# Git stash
`git stash` is handy if you need to quickly switch context and work on something else, but **changes** made in **working directory** are **not ready** to be committed.

<br>

|Command|Description|
|:------|:----------|
|`git stash`|Saves **uncommitted changes** (both **staged** and **unstaged**) for later use.|
|`git stash list`|To view list of saved stashes.|
|`git stash pop`|**Reapply** the **most recently created stash** `stash@{0}` to your **working directory** and **delete** it from stash.|
|`git stash pop stash@{2}`|**Reapply** the **particular stash** `stash@{2}` to your **working directory** and **delete** it from stash.|
|`git stash drop stash@{1}`|Delete **particular stash** `stash@{1}` from stash.|
|`git stash clear`|**Delete all** of your stashes.|

<br>

By default `git stash` will stash:
- changes that have been **added to your index** (**staged changes**);
- changes made to files that are **currently tracked by Git** (**unstaged changes**).

<br>

But `git stash` will **not** stash:
- **new files** in your **working directory** that **have not yet been staged**;
- files that are **ignored**.

<br>

Option `-u` tells git also stash **untracked** files.
Option `-a` tells git also stash **ignored** files.
