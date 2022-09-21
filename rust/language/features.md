# Features
**Features** provide a **mechanism** for **conditional compilation**.<br>
**Features** are defined in the ``[features]`` section of ``Cargo.toml`` file.<br>
**Each feature** can either be **enabled** or **disabled**.

<br>

Properties of features:
- Each *feature* specifies an **array** of **other features** or **optional dependencies** that it enables;
- If *feature* is enabled it in turn enables the listed features in array;
- Empty array means that feature does not enable any other features;
- *By default*, **all features are disabled** unless **explicitly enabled** or **listed in default feature**.

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

## Ways to manage features
- *Features* for the **package being built** are managed by **command-line flags**.
- *Features* of **dependencies** are managed in the **dependency declaration**;
- *Features* of **dependencies** are also managed in the ``[features]`` table,  the syntax is ``feature_name = ["package-name/feature-name"]``.

### Command-line flags to mange features
|CLI flag|Description|
|:---|:----------|
|``--features FEATURES``|Here ``FEATURES`` is a **space** or **comma** separated **list of features** to activate. Example:`` --features "foo bar"``|
|``--no-default-features``|**Disables default feature**|
|``--all-features``|Activates all available features of all packages|

### Dependency declaration attributes to mange features
Attributes to manage dependencies in ``[dependencies]`` section:
|Attribute|Description|
|:--------|:----------|
|``features=["foo", "bar"]``|Comma separated **list of features** to activate.|
|``default-features=true/false``|**Enables** or **disables** any **defaults** provided by the dependency.|
|``optional=true``|``optional=true`` means that such dependency **will not be compiled by default**.|

#### Example
```Rust
[dependencies]
foo1 = { version = "0.1", features=["bar1", "baz1"] }
foo2 = { version = "0.2", features=["baz2"], default-features = false }
foo3 = { version = "0.3", optional = true }
```

### ``package-name/feature-name`` in the ``[features]`` table

*Features* of **dependencies** can also be enabled in the ``[features]`` table.<br>
The syntax is ``feature_name = ["package-name/feature-name"]``.

#### Example
```Rust
[dependencies]
foo = { version = "0.1", default-features = false }

[features]
baz = ["foo/bar"]
```

<br>

## Default feature
There is special feature: **default feature**.<br>
*By default*, **default feature** is **enbaled**.<br>

#### Example
```Rust
[features]
default = ["ico", "webp"]
bmp = []
png = []
ico = ["bmp", "png"]
webp = []
```

#### Ways to disable **default feature** 
- The ``--no-default-features`` *command-line flag* **disables** the **default feature** of **the package**.
- The ``default-features = false`` *attribute* of a dependency declaration **disables** the **default feature** of **the dependency**.

<br>

## Optional dependencies
#### Example
```Rust
[dependencies]
gif = { version = "0.11.1", optional = true }
```

By default, above optional dependency ``gif`` **implicitly defines a feature** ``gif`` that looks like this:
```Rust
[features]
gif = ["dep:gif"]
```

This means that **dependency** ``gif`` will only be included if the ``gif`` **feature** is **enabled**.<br>
The same ``cfg(feature = "gif")`` syntax can be used in the code, and the dependency can be enabled by ``--features gif``.

In some cases, you may not want to expose a feature that has the same name as the optional dependency.<br>
For example, perhaps the optional dependency is an internal detail, or you want to group multiple optional dependencies together, or you just want to use a better name.<br>
If you specify the **optional dependency** with the ``dep:`` prefix **anywhere in the** ``[features]`` **table**, this **disables** the **implicit feature**.<br>

**Note**: The ``dep:`` syntax is only available starting with ``Rust 1.60``.<br>

For example, let's say in order to support the **AVIF** image format, our library needs two other dependencies to be enabled:
```Rust
[dependencies]
ravif = { version = "0.6.3", optional = true }
rgb = { version = "0.8.25", optional = true }

[features]
avif = ["dep:ravif", "dep:rgb"]
```

In this example, the ``avif`` feature will enable the two listed dependencies.<br>
This also avoids creating the implicit ``ravif`` and ``rgb`` features, since we don't want users to enable those individually as they are internal details to our crate.
