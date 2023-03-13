# `git checkout`
Consider example:
```bash
git checkout foo
error: The following untracked working tree files would be overwritten by checkout
 ...
Please move or remove them before you can switch branches.
Aborting
```

<br>

This is caused by following, suppose you have some file in **tag** `1.3.1`, e.g., `migrations/INIT.sql`, but in tag `1.0.0` you have not this file.<br>
If you *checkout* to tag `1.0.0` and create there file `migrations/INIT.sql` even with the same content `git` **rejects** your attempt to *checkout* into tag `1.3.1`.<br>
If you provide `-f` option then `git checkout -f` will *checkout* and overwrites file `migrations/INIT.sql` from tag `1.3.1`.<br>

Also you can call `git clean` to **explicitly clear workdir** before `git checkout`.
