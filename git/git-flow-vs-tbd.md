# Table of contents
<!-- TOC -->
* [Table of contents](#table-of-contents)
* [Git branching strategies](#git-branching-strategies)
* [TBD](#tbd)
  * [Development model](#development-model)
* [Git Flow](#git-flow)
  * [Development model](#development-model-1)
    * [Supporting branches](#supporting-branches)
  * [Feature branches](#feature-branches)
  * [Release branches](#release-branches)
  * [Hotfix branches](#hotfix-branches)
<!-- TOC -->

<br>

# Git branching strategies
A **git branching strategy** defines how developers **manage different versions** of code and **collaborate on shared repositories**.<br>
Git branching strategy defines **a set of rules** that guide the **development process**, **code integration**, **release management**, and **error tracking**.<br>

Popular git branching strategies:
- **TBD** (Trunk Based Development);
- **GitFlow** and its variations;

<br>

# TBD
**Trunk-based development** (**TBD**) is a **git branching strategy** where developers collaborate in a single branch called **trunk** (**mainline** branch) and make **smaller changes more frequently**.<br>
Unlike feature branching, branches in trunk-based development are short-lived, lasting no more than a few hours.<br>
**Trunk-based development** is often combined with **feature flags** – or **feature toggles**.<br>
**Feature flags** are used to isolate unstable features to be deployed. So any new features can be deployed as soon as they are ready and rolled back easily in case of bugs.<br>

<br>

## Development model
**Mainline branch** contains the **latest** features and bugfixes. **Mainline binaries** are built from the **mainline branch**.<br>
**Mainline version** (aka **mainline release**) is the **latest development version**, updated approximately every 1 or 2 months, includes the latest features, bug fixes and security fixes.<br>
The _Mainline version_ always has an **odd middle number**, for example, 1.**27**.X.<br>
The _Mainline version_ is recommended for production **unless** your organization has **strict requirements for stability**, in which case the **stable** version might be the **better choice**.<br>

<br>

**Stable version** (also **stable release**) is updated typically **once a year**.<br>
This version is recommended for environments with strict requirements for stability.<br>
The _Stable version_ is always **even-numbered**, for example, 1.**28**.X.<br>

**Stable binaries** are built from **stable release** and only contain critical fixes backported from the _mainline version_.<br>

<br>

# Git Flow
## Development model
The central repo holds **two** main branches with an **infinite lifetime**:
- `master` or `main`: aka **mainline branch**, the branch where the source code is ready for production **production-ready**;
- `develop` or `dev`: the branch where the source code always reflects the **latest changes** for the **next release**;

Every commit on `master` is a **new release** by definition.<br>

<br>

### Supporting branches
Unlike the main branches, these branches always have a **limited life time**:
The different types of branches we may use are:
- **feature** branches;
- **release** branches;
- **hotfix** branches;

<br>

## Feature branches
*Feature branches* are forked off a `develop` branch.<br>
*Feature branches* **must** merge back into: `develop` branch.<br>

<br>

Naming convention for feature branches:
Consider, project has name **foo**, feature has name **abc** and this feature has id **NN** in task tracker:
- `feature-abc`
- `FOO-NN`
- `feature/FOO-NN`
- ...

<br>

Creating a **new feature branch**:
- `git checkout -b FOO-NN dev`

<br>
Finished features may be merged into the develop branch. So, create PR/MR, merge and **update tag**.<br>

<br>

**Use** `--no-ff` flag when merging to **upstream** branch.<br>
The `--no-ff` flag causes the merge to always create a **new commit object**, even if the merge could be performed with a fast-forward.<br>

<br>

## Release branches
*Release branches* are forked off a `develop` branch.<br>
*Release branches* **must** be merged **back** into: `develop` and `master` branches.<br>

<br>

Naming convention for **release branches**:
- `release/*`
- `release-*`

<br>

Creating a **new release branch**:
- `git checkout -b release/0.1.0 dev`

<br>

When finished, the **bugfix** needs to be merged back into `master`, but also needs to be merged back into `develop`.<br>
So, create PR/MR, merge and **update tag**.<br>

<br>

## Hotfix branches
*Hotfix branches* are branched off from the **corresponding tag** on the `master` branch.<br>
*Hotfix branches* **must** be merged **back** into: `develop` and `master` branches.<br>

Naming convention for **hotfix branches**:
- `hotfix/*`
- `hotfix-*`

<br>

Creating a **new hotfix branch** (with new patch version):
- `git checkout -b hotfix/0.1.1 dev`

<br>

When finished, the **bugfix** needs to be merged back into `master`, but also needs to be merged back into `develop`.<br>
So, create PR/MR, merge and **update tag**.<br>
