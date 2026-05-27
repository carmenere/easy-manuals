# Table of contents
- [Table of contents](#table-of-contents)
- [Conventional commits](#conventional-commits)
  - [Specification](#specification)
  - [Breaking changes indicator](#breaking-changes-indicator)
  - [Types](#types)
  - [Examples](#examples)

<br>

# Conventional commits
General commit message format:
<pre>
<b><a href="#types">&lt;type&gt;</a></b></font>(<b><a href="#scopes">&lt;optional scope&gt;</a></b>): <b><a href="#description">&lt;description&gt;</a></b>
<sub>empty line as separator</sub>
<b><a href="#body">&lt;optional body&gt;</a></b>
<sub>empty line as separator</sub>
<b><a href="#footer">&lt;optional footer&gt;</a></b>
</pre>

<br>

**Example**:
```bash
git commit -m "<type>(<optional scope>): <description>" -m "<optional body>" -m "<optional footer>"
```

<br>

## Specification
The `<type>(<scope>): <description>` part of *conventional commit* is a **subject** of *commit message*:
- a `(<scope>)` is **optional**;
- a `(<scope>)` **must** consist of a **noun** describing a section of the codebase surrounded by parenthesis, e.g., `fix(parser)`;
- the `<description>` is a **short summary** of the code changes, e.g., `fix: array parsing issue when multiple spaces were contained in string`;

<br>

## Breaking changes indicator
- a commit that introduces *breaking changes* **must** be indicated by an `!` before the `:` in the `<description>` part e.g. `feat(api)!: remove status endpoint`;
- if the `<description>` **isn't** sufficiently informative then *commit message* also **should** be described in the **footer** `BREAKING CHANGE`;

<br>

## Types
- `feat` commits that **add**, **adjust** or **remove** a **feature**;
- `fix` commits that **fix** a feat;
- `style` commits that **improve** the **code style** without changing its logic (e.g., formatting);
- `refactor` commits that **modify** the code **without** adding new features or fixing bugs;
- `perf` commits that **improve performance**;
- `test` commits that **add** or **modify tests**;
- `docs` commits that **adds** or **updates documentation**;
- `ci`: commits that **change CI/CD pipeline**, this typically involves editing YAML files for tools like *GitHub Actions*, *GitLab CI*, *CircleCI* or *Jenkins*
  - `.gitlab-ci.yml` and so on;
- `build` commits that affect **logic that builds the app**:
  - **toolchain**;
  - **dependency management**: bumping versions of libraries or packages;
- `ops` commits that affect **logic that manages the environment where the app runs** such as
  - **deployment scripts**;
  - **backups**;
  - **monitoring**;
  - **recovery procedures**;
- `chore` commits **for technical tasks** that keep the repository or development environment healthy
  - modifying files like `.gitignore`, `.dockerignore` and so on;
  - **initializing** a repository;
  - adding **license files**;
  - also for **dependency management**: bumping versions of libraries or packages;

<br>

**Examples**:
```
build: update dependencies
build: change webpack config

ci: add GitHub Action for linting
ci: fix Travis build

ops: update k8s manifests
ops: fix monitoring alerts

chore: add .gitignore
chore: release v1.0.0
```

<br>

## Examples
- *Commit message* with `!` to draw attention to **breaking change**
```
feat!: send an email to the customer when a product is shipped
```
- *Commit message* with **scope** and `!` to draw attention to **breaking change**
```
feat(api)!: send an email to the customer when a product is shipped
```
- *Commit message* with **both** `!` and `BREAKING CHANGE` **footer**
```
feat!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```
- *Commit message* with **no body**
```
docs: correct spelling of CHANGELOG
```
- *Commit message* with **scope**
```
feat(lang): add Polish language
```
- *Commit message* with multi-paragraph body and multiple footers
```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```