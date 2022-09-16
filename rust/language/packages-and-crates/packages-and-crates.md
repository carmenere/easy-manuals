# Registry
A **registry** is a storage for **packages**. 

The *crates.io* is the Rust community’s **package registry**. 
Each package can be published on https://crates.io independently. 
Each package can be fetched from https://crates.io.

<br>

# Packages and Crates
A **package** is a *collection* of **crates**.  

Every **package** contains **at least 1 crate**.
Every **package** has **Cargo.toml** file also called **package’s manifest**. **Directory** with *Cargo.toml* file is called **package root**.

- *Cargo.toml* file contains **settings for package**.
- *Cargo.toml* file is written in the **TOML format**. 

Every *Cargo.toml* file consists of the following sections:

|Section|Description|
|:------|:----------|
|``[workspace]``|Workspace settings.|
|``[package]``|Package settings.|
|``[features]``|**Conditional compilation** features.|
|``[lib]``|**Library crate** settings.|
|``[[bin]]``|**Binary crate** settings.|
|``[dependencies]``|Package dependencies.|
|``[dev-dependencies]``|Dependencies for **examples**, **tests**, and **benchmarks**.|
|``[build-dependencies]``|Dependencies for **build scripts**.|
|``[target]``|**Platform-specific** dependencies.|

More details here: https://doc.rust-lang.org/cargo/reference/manifest.html.

<br>

# Targets
``[lib]``, ``[[bin]]``, ``[[example]]``, ``[[test]]`` and ``[[bench]]`` sections are also called **target tables** (aka **targets**).

Every **target** describes **settings for some crate**.

There are **2 types** of **crates**:
- **binary crate**: defined in ``[[bin]]``.
- **library crate**: defined in ``[lib]``. 

The **double-bracket section** like ``[[bin]]`` is an **array-of-tables**. It means you can write **more than one** ``[[bin]]`` section to describe several crates in 1 package.
So, 
- there **can only be 1 library crate** within package; 
- there **can be more than 1 binary crate** within package.

Compiler will produce **executable** for *binary crate* and **library** for *library crate*.

<br>

# Crate’s module tree
A **crate** consists of a **hierarchy of modules**, called **crate’s module tree**, i.e., crate is an **independent compilation unit** within package.

A **module** is a **collection of items**. **Module** acts as **namespace for items**.

The **module tree** *must be built manually*. It means **every .rs file in package** is included to *module tree* **explicitly** by ``mod`` **keyword**.

Every *module tree* has a **root module**. 

- The *root module* is an **entry point** into *crate*. 
- The *root module* **always corresponds to some .rs fil**e in *package*.

<br>

# Crate auto-discovery
Cargo uses the **automatic target discovery** by default. 

*Automatic target discovery* uses **package layout convention**. *Automatic target discovery* **can be disabled**.

**Package layout’s convention**:
- ``Cargo.toml`` and ``Cargo.lock`` are stored in **package root**.
- Directory ``src`` contains **source code**.
- File ``src/lib.rs`` corresponds to the **root module** of **library crate**.
- File ``src/main.rs`` corresponds to the **root module** of **binary crate**.
- Directory ``src/bin`` for other crates.

<br>

# The ``[package]`` section settings
Fields ``name`` and ``version`` are **required**.

The **package name** is an identifier used to refer to the package. 
It is used when listed as a dependency in another package.

By default, the ``name`` *field* of the ``[package]`` *section* is **used as name** for *auto discovered crate* with *root module* ``src/main.rs``.
**Any dashes** in the ``name`` *field* of the ``[package]`` *section* are **replaced** with **underscores**.

<br>

# Targets settings
All targets (``[lib]``, ``[[bin]]``, ``[[example]]``, ``[[test]]``, ``[[bench]]``) have the same configurable fields.

- The ``path`` field specifies path to **root module**, *relative* to the **package root**.
- The ``name`` field specifies the **name of the crate**. 

The name field is **optional** *for library crate* and is **required** *for all other crates*.

By default, the ``name`` *field* of the ``[package]`` *section* is **used as name** for *auto discovered crate* with *root module* ``src/main.rs``.

<br>

### Example
```toml
[[bin]]
name = "foo"
test = false
bench = false

[[bin]]
name = "bar"
required-features = ["baz"]
```

More on fields here: https://doc.rust-lang.org/cargo/reference/cargo-targets.html.
