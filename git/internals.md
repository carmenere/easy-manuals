# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [git for-each-ref](#git-for-each-ref)
* [git cat-file](#git-cat-file)
* [git log](#git-log)
* [git rev-list](#git-rev-list)
* [Dangling commits](#dangling-commits)
  * [Find dangling commits](#find-dangling-commits)
  * [Remove dangling commits](#remove-dangling-commits)
* [git show](#git-show-)
* [git-ls-remote](#git-ls-remote)
* [git show-ref](#git-show-ref)
<!-- TOC -->

<br>

# git for-each-ref
`git for-each-ref` tells you what each **ref** is to by default, its **id** and its **type**.<br>

**Example**:
```bash
git for-each-ref
5b8a5c08ce28639e788734b2528faad70baa113c commit	refs/heads/master
5b8a5c08ce28639e788734b2528faad70baa113c commit	refs/remotes/origin/HEAD
fb89d50eeb19d42d83144ff76c80d20e80c41aca commit	refs/remotes/origin/default
5b8a5c08ce28639e788734b2528faad70baa113c commit	refs/remotes/origin/master
b42ef0b68d2303d795ebfd81e185d992094a8b8f commit	refs/remotes/origin/stable-0.5
f6f8d515885fcda20f09b83583d576337fbabe0a tag	refs/tags/release-1.28.0
479e06d88b14ea2b4512545825ccce48ca7ec028 commit	refs/tags/release-1.3.0
```

<br>

To restrict it to just **tags**, do `git for-each-ref refs/tags`:
```bash
git for-each-ref refs/tags
801c5875f4daedc9ed24e7da80401203f77e65b1 commit	refs/tags/release-1.9.3
00ec3b73364fd23c05ccfc0d9eec45455840a174 commit	refs/tags/release-1.9.4
658813c43b9c930c8fad2cd04600d1aba2ef031b commit	refs/tags/release-1.9.5
```

<br>

# git cat-file
A **lightweight tag** is a name in **refs/tags** that refers to a **commit object**.
An **annotated tag** is a name in **refs/tags** that refers to a **tag object**.

The `git cat-file` command can show type of specific commit.

**Examples**:
```bash
git cat-file -t 801c5875f4daedc9ed24e7da80401203f77e65b1
commit
```

```bash
git cat-file -t f6f8d515885fcda20f09b83583d576337fbabe0a
tag
```

<br>

The **option** `--batch-check` or `--batch-check=<format>` prints object information for **each** object provided on **stdin**.<br>

**Example** (in combination with `git rev-list`):
```bash
git rev-list a22a4f4847ff04005ba1b50b227933e6e816c55d | head -n 3 | git cat-file --batch-check='%(objectname) %(objecttype)'
```

<br>

# git log
Show commits in **chronological order**:
```bash
git log --pretty=format:"%H %d" --reverse --ancestry-path 6865efd4759b4cd5349f9e6b014017e099383e84^..master
6865efd4759b4cd5349f9e6b014017e099383e84  (tag: release-1.7.1)
437cb7b6631c26ad74f992c4745b42ae2836105b
a22a4f4847ff04005ba1b50b227933e6e816c55d  (tag: release-1.7.2)
```

<br>

Show commits in **reverse chronological order**:
```bash
git log --pretty=format:"%H %d"  6865efd4759b4cd5349f9e6b014017e099383e84
6865efd4759b4cd5349f9e6b014017e099383e84  (tag: release-1.7.1)
e36718de4b3570b8174bb76787ca6c73386bbb9f
215497a467a34003c5259b832da4678f33d163b4  (tag: release-1.7.0)
```

<br>

`git log --pretty=format:"%h %ad- %s [%an]"`

Here:
- `%h`: short commit hash
- `%H`: full commit hash
- `%s`: subject (aka commit title)
- `%b`: body (commit message without title)
- `%B`: full commit message: title + body
- `%an`: author name
- `%ae`: author email 
- `%cn`: committer name
- `%ce`: committer email

<br>

| Date placeholder | Format                             | Example                                    |
|:-----------------|:-----------------------------------|:-------------------------------------------|
| %ad, %cd         | respects `--date=<format>` option  | **Mon** **Jun** 2 17:04:27 **2025** +0300  |
| %aD, %cD         | **RFC2822**                        | **Mon**, 2 **Jun** **2025** 17:04:27 +0300 |
| %at, %ct         | **UNIX** timestamp                 | 1748873067                                 |
| %aI, %cI         | strict **ISO 8601** format         | **2025**-06-02T17:04:27+03:00              |
| %as, %cs         | **short** format (YYYY-MM-DD)      | **2025**-06-02                             |
| %ar, %cr         | **relative**                       | 18 minutes ago                             |


The letter `a` in _date placeholder_ means **author date**: the date when the **original changes** were made.<br>
The letter `c` in _date placeholder_ means **committer date**: the date when the changes were made, for example, during a rebase or amend operation.<br>

<br>

**Example**:
```bash
git log --pretty=format:"%H | %ad | %aD | %at | %aI | %as | %ar"
git log --pretty=format:"%H | %cd | %cD | %ct | %cI | %cs | %cr"
```

<br>

# git rev-list
The `git rev-list` command is a **very complicated**, **very central** command in Git, as what it does is **walk the graph**.<br>

By default, `git rev-list` shows objects in **reverse chronological order** which are **reachable** from some commit.<br>
By default it similar to `git log`.<br>

**Consider example**:
```bash
git log --pretty=format:"%H %d" a22a4f4847ff04005ba1b50b227933e6e816c55d -3
a22a4f4847ff04005ba1b50b227933e6e816c55d  (tag: release-1.7.2)
52222dcda66126aaf073083b752c29d4425b9511
bec7415b854777108ea0847500948bedd569fb20
```

```bash
git rev-list a22a4f4847ff04005ba1b50b227933e6e816c55d | head -n 3
a22a4f4847ff04005ba1b50b227933e6e816c55d
52222dcda66126aaf073083b752c29d4425b9511
bec7415b854777108ea0847500948bedd569fb20
```

<br>

But we can **specify** exactly which **parts of the graph** the `git rev-list` must walk. You can think of this as a **set operation**.<br>
Commits **reachable** from any of the commits given on the command line **form a set**, and then commits reachable from any of the ones given with `^` in front are **subtracted** from that set.<br>
Thus, the following command: `git rev-list foo bar ^baz` means "list all the commits which are **reachable** from `foo` or `bar`, but **not** from `baz`".<br>

A special notation `<commit1>..<commit2>` can be used as a short-hand for `^<commit1> <commit2>`.<br>
For example, either of the following may be used **interchangeably**:
- `git rev-list origin..HEAD`
- `git rev-list ^origin HEAD`

<br>

Another special notation is `<commit1>...<commit2>` which is useful for merges.
The resulting set of commits is the **symmetric difference** between the **two commits**. The following two commands are equivalent:
- `git rev-list A B --not $(git merge-base --all A B)`
- `git rev-list A...B`

<br>

The `--not` operator effectively **flips** the `^` on each ref after it:
- `git rev-list --not feature1 feature2 ^main` is a **shorthand** for `git rev-list ^feature1 ^feature2 main`;

<br>

# Dangling commits
## Find dangling commits
1. `git branch --contains <commit>` returns list of **all branches** that **contain commit** `<commit>`
2. `git fsck --lost-found`
3. `git fsck --lost-found 2>&1 | grep "dangling commit"`
4. `git fsck --unreachable --no-reflogs`

<br>

**Example**:
```sh
git rev-list --all | while read COMMIT; do echo "$COMMIT: $(git branch --contains $COMMIT)"; done
```

<br>

## Remove dangling commits
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
