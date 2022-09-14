# Group types
There are 2 types of groups in linux: 
1. **Primary** group. By default, when creating a new account (user), a **Primary** group is created for it with the same name as the account.
2. **Secondary** group. Additional group that the user account can belong to. Used to expand access rights.

**Account** (**user**) can belong to **one** *Primary* group and to **many** *Secondary* groups.

Commands to view the **Primary** group and all **Secondary** groups to which the current user belongs:
1. ``id``
```bash
id
uid=1004(an.romanov) gid=1004(an.romanov) groups=1004(an.romanov),27(sudo),120(libvirt),998(docker)
```

2. ``groups``
```bash
groups
an.romanov sudo libvirt docker
```

<br>

# Changing primary group for user
```bash
usermod -g ${GROUP} ${USER}
````

This command changes **primary** group to ``${GROUP}`` for user ``${USER}``.

Example:
```bash
$ id test
uid=1001(test) gid=1001(test) groups=1001(test),1002(foobar)

$ usermod -g foobar test

$ id test
uid=1001(test) gid=1005(foobar) groups=1005(foobar),1002(foobar)
```

<br>

# Account management
## Create/Delete user or group
|Command|Description|
|:------|:----------|
|``useradd``|Low level tool.|
|``adduser``|Perl script, wrapper on ``useradd``.|
|``groupadd``|Low level tool.|
|``addgroup``|Perl script, wrapper on ``groupadd``.|
|``userdel``|Low level tool.|
|``deluser``|Perl script, wrapper on ``userdel``.|
|``groupdel``|Low level tool.|
|``delgroup``|Perl script, wrapper on ``groupdel``.|

<br>

### ``adduser`` options
``--disabled-login`` Do not run passwd to set the password.  The user won't be able to use her account until the password is set.<br>
``--disabled-password`` Like ``--disabled-login``, but logins are still possible (for example using SSH RSA keys) but not using password authentication.<br>
``--gecos GECOS`` Set the gecos field (comment field) in ``/etc/passwd`` file for the new entry.

<br>

## Add user to Secondary groups
|Command|Description|
|:------|:----------|
|``adduser``|Can only add a user to **one group at a time**. Adds **incrementally**, i.e. **retains membership** in other secondary groups.|
|``usermod``|Can add a user to the list of groups at a time, by default *removes* the user from all other secondary groups. To **incrementally** add groups to secondary, you must use the **-a** option.|


### adduser
```bash
adduser ${USER} ${GROUP}
```

### usermod
```bash
usermod -a -G ${GROUP_1},${GROUP_2} ${USER}
```
