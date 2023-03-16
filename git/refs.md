A Git reference (git ref) is a file that contains a Git commit SHA-1 hash. When referring to a Git commit, you can use the Git reference, which is an easy-to-remember name, rather than the hash. The Git reference can be rewritten to point to a new commit. A branch is a Git reference that stores the new Git commit hash.


A ref is an indirect way of referring to a commit. 

You can think of it as a user-friendly alias for a commit hash. This is Git’s internal mechanism of representing branches and tags.

Refs are stored as normal text files in the .git/refs directory, where .git is usually called .git.

The tags directory works the exact same way, but it contains tags instead of branches. The remotes directory lists all remote repositories that you created with git remote as separate subdirectories. Inside each one, you’ll find all the remote branches that have been fetched into your repository.

When passing a ref to a Git command, you can either define the full name of the ref, or use a short name and let Git search for a matching ref.

fully qualified ref 

<CURR_BRANCH> имя ТЕКУЩЕГО бранча  (git branch --show-current), т.е. того бранча в который был сделан последний checkout. 

remote.<name>.url
	The URL of a remote repository. See git-fetch[1] or git-push[1].

remote.<name>.fetch
	The default set of "refspec" for git-fetch[1]. See git-fetch[1].

remote.<name>.push
	The default set of "refspec" for git-push[1]. See git-push[1].

push.default
	Defines the action git push should take if no refspec is given (whether from the command-line, config, or elsewhere).
	Different values are well-suited for specific workflows; for instance, in a purely central workflow (i.e. the fetch source is equal to the push destination), upstream is probably what you want.
	Possible values are:

		nothing - do not push anything (error out) unless a refspec is given.
		This is primarily meant for people who want to avoid mistakes by always being explicit.
		current - push the current branch to update a branch with the same name on the receiving end.
		Works in both central and non-central workflows.
		
		upstream - push the current branch back to the branch whose changes are usually integrated into the current branch (which is called @{upstream}).
		This mode only makes sense if you are pushing to the same repository you would normally pull from (i.e. central workflow).
		tracking - This is a deprecated synonym for upstream.
		
		simple - pushes the current branch with the same name on the remote.
		If you are working on a centralized workflow (pushing to the same repository you pull from, which is typically origin), then you need to configure an upstream branch with the same name.

		This mode is the default since Git 2.0, and is the safest option suited for beginners.

		matching - push all branches having the same name on both ends.
		This makes the repository you are pushing to remember the set of branches that will be pushed out (e.g. if you always push maint and master there and no other branches, the repository you push to will have these two branches, and your local maint and master will be pushed there).

		To use this mode effectively, you have to make sure all the branches you would push out are ready to be pushed out before running git push, as the whole point of this mode is to allow you to push all of the branches in one go.
		If you usually finish work on only one branch and push out the result, while other branches are unfinished, this mode is not for you.
		Also this mode is not suitable for pushing into a shared central repository, as other people may add new branches there, or update the tip of existing branches outside your control.

		This used to be the default, but not since Git 2.0 (simple is the new default).


branch.<name>.remote
	When on branch <name>, it tells git fetch and git push which remote to fetch from/push to.
	The remote to push to may be overridden with remote.pushDefault (for all branches). The remote to push to, for the current branch, may be further overridden by branch.<name>.pushRemote.
	If no remote is configured, or if you are not on any branch and there is more than one remote defined in the repository, it defaults to origin for fetching and remote.pushDefault for pushing. 
	Additionally, . (a period) is the current local repository (a dot-repository), see branch.<name>.merge's final note below.


branch.<name>.pushRemote
	When on branch <name>, it overrides branch.<name>.remote for pushing. It also overrides remote.pushDefault for pushing from branch <name>. When you pull from one place (e.g. your upstream) and push to another place (e.g. your own publishing repository), you would want to set remote.pushDefault to specify the remote to push to for all branches, and use this option to override it for a specific branch.


remote.pushDefault
	The remote to push to by default.
	Overrides branch.<name>.remote for all branches, and is overridden by branch.<name>.pushRemote for specific branches.




branch.<name>.merge
	Defines, together with branch.<name>.remote, the upstream branch for the given branch.
	It tells git fetch/git pull/git rebase which branch to merge and can also affect git push (see push.default).
	When in branch <name>, it tells git fetch the default refspec to be marked for merging in FETCH_HEAD.
	The value is handled like the remote part of a refspec, and must match a ref which is fetched from the remote given by "branch.<name>.remote".
	The merge information is used by git pull (which at first calls git fetch) to lookup the default branch for merging.
	Without this option, git pull defaults to merge the first refspec fetched.
	Specify multiple values to get an octopus merge.
	If you wish to setup git pull so that it merges into <name> from another branch in the local repository, you can point branch.<name>.merge to the desired branch, and use the relative path setting . (a period) for branch.<name>.remote.








Порядок определения репозитория для git push: 
branch.<CURR_BRANCH>.pushRemote -> remote.pushDefault -> branch.<CURR_BRANCH>.remote -> origin
Порядок определения репозитория для git fetch: -> branch.<CURR_BRANCH>.remote -> origin.







[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
	precomposeunicode = true
[remote "origin"]
	url = git@github.com:softwarebaker/easy-manuals.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
	remote = origin
	merge = refs/heads/main
[branch "EM-46"]
	remote = origin
	merge = refs/heads/EM-46
	pushRemote = abc
[push]
	default = matching
[remote]
	pushDefault = abc

git push
fatal: 'abc' does not appear to be a git repository
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.






git-show-ref - List references in a local repository

SYNOPSIS
git show-ref [-q | --quiet] [--verify] [--head] [-d | --dereference]
	     [-s | --hash[=<n>]] [--abbrev[=<n>]] [--tags]
	     [--heads] [--] [<pattern>…​]
git show-ref --exclude-existing[=<pattern>]
DESCRIPTION
Displays references available in a local repository along with the associated commit IDs. Results can be filtered using a pattern and tags can be dereferenced into object IDs. Additionally, it can be used to test whether a particular ref exists.


