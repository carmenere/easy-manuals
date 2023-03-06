git checkout <branch>
error: The following untracked working tree files would be overwritten by checkout
 ...
Please move or remove them before you can switch branches.
Aborting

This is caused by following, suppose you have some file in Release_1.3.1, e.g., migrations/20211011052324_INIT.sql, but in tag Release_0.8.4 you have not this file.
If you checkout to Release_0.8.4 and create there file migrations/20211011052324_INIT.sql even with the same content than git rejects your attempt to checkout into Release_1.3.1. If you call it checkout -f git will checkout and overwrites file migrations/20211011052324_INIT.sql from Release_1.3.1.


Also you can call git clean to explicitly clear workdir before.

git clean  -d  -f .
git clean  -d  -fx .

-x means ignored files are also removed as well as files unknown to git.

-d means remove untracked directories in addition to untracked files.

-f is required to force it to run.

--dry-run