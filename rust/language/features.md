# Features
**Features** provide a **mechanism** for **conditional compilation**.<br>
**Features** are defined in the ``[features]`` section of ``Cargo.toml`` file.<br>

<br>

#### Example
```Rust
[features]
bmp = []
png = []
ico = ["bmp", "png"]
foo = []
```

Then feature ``foo`` can be used to conditionally include **any item** in code, for instance, module ``bar``:
```Rust
#[cfg(feature = "foo")]
pub mod bar;
```

<br>

### Properties of features
- Each *feature* specifies an **array** of **other features**;
- If *feature* is enabled it in turn enables the listed features in array;
- Empty array means that feature does not enable any other features;
- *By default*, **all features are disabled** unless **explicitly enabled** or **listed in default feature**.

<br>

### Ways to enable feature
- **Command-line flag** ``--features`` is used to enable **features of current package**;
- **Dependency declaration** in ``Cargo.toml`` is used to enable **features of dependencies**.

<br>

## Command-line feature options
The following command-line flags can be used to control which features are enabled:
- ``--features FEATURES`` **space** or **comma** separated list of features to activate. Example:`` --features "foo bar"``;
- ``--no-default-features``: **disable  default feature**;
- ``--all-features`` activates all available features of all packages.

<br>

## Dependency declaration syntax
**Features of dependencies** can be enabled within the **dependency declaration** syntax in ``Cargo.toml``.

<br>

#### Example
```Rust
[dependencies]
serde = { version = "1.0.118", features = ["derive"] }
flate2 = { version = "1.0.3", default-features = false, features = ["zlib"] }
```

<br>

## Default features

#### Example
```Rust
[features]
default = ["ico", "webp"]
bmp = []
png = []
ico = ["bmp", "png"]
webp = []
```

Ways to disable **default feature** *in dependecy*:
- The command-line flag ``--no-default-features`` disables the default features of the package.
- The key value pair: ``default-features = false`` can be specified in a **dependency declaration**.

<br>

## Optional dependencies
Dependencies can be marked **optional**, which means they **will not be compiled by default**.

Example:
```Rust
[dependencies]
gif = { version = "0.11.1", optional = true }
```
