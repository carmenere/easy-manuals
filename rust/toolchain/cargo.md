# Description
``cargo`` is both the **package manager** and the **build system** for Rust.

<br>

# ``cargo`` subcommands
|Subcommand|Explanation|
|:---------|:----------|
|cargo **new** ``foo``|Creates **new** *directory* ``foo`` and fills it by: **<ul><li>src/main.rs</li><li>Cargo.toml</li><li>.git</li><li>.gitignore</li></ul>** Sets ``foo`` as name for **package**.|
|cargo **init**|Create files in **current working** *directory*: **<ul><li>src/main.rs</li><li>Cargo.toml</li><li>.git</li><li>.gitignore</li></ul>** Sets name of **current working** *directory* as name for **package**.|
|cargo **init** ``foo``|Acts like the ``cargo new foo`` command, i.e., equal to the ``cargo new foo`` command.|
|cargo **run**|**Compiles** and **runs**. Creates ``target`` directory in ``src`` directory.|
|cargo **build**|Just **compiles**. Creates ``target`` directory in ``src`` directory.|
|cargo **build** ``--release``|Just **compiles** for **production**. Creates ``target`` directory in ``src`` directory. Also creates ``release`` directory in ``src/target`` directory.|
|cargo **check**|Runs **unit tests**.|
|cargo **doc**|Generates **documentation**.|
|cargo **install** ``<crate_name>``|Installs **binary** of **crate** with name ``<crate_name>`` from the default registry ``crates.io``.|
