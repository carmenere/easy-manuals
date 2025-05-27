# Git development model

## Branches
### The main branches
The central repo holds **two** main branches with an **infinite lifetime**:
- `master` or `main`: the branch where the source code always reflects a **production-ready** state;
- `develop` or `dev`: the branch where the source code always reflects the latest delivered development changes for the next release

<br>

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

Use `--no-ff` flag when merging to upstream branch.<br>
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
