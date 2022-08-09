# Description
``rustup`` is a **toolchain multiplexer**. <br>
``rustup`` can **install** and **manage** <mark>many</mark> toolchains simultaneously. <br>
``rustup`` provides mechanisms to easily change the **active** (**default**) toolchain.

<br>

# Installation
Install ``rustup``:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

<br>

# Profiles
``rustup`` has the concept of **profiles**. 

**Profile** is a **group of components** you can choose to download while installing a *toolchain*. 

The profiles available now
- ``minimal``
- ``default``
- ``complete``

<br>

# ``rustup`` subcommands
|Subcommand|Explanation|
|:---------|:----------|
|rustup **show**|Print **default** *target triple* and other information.|
|rustup **toolchain list**|List **all** installed toolchains.|
|rustup **toolchain install** ``nightly``|Installs last toolchain for release channel ``nightly`` for current date.|
|rustup **default** ``nightly``|Sets the **default toolchain** to ``nightly``.|
|rustup **update**|Updates **default toolchain**.|
|rustup **component list**|Lists of **available** and **installed** components.|
|rustup **component add** ``rust-docs``|Adds component ``rust-docs`` to default toolchain.|
|rustup **set profile** ``minimal``|To select the ``minimal`` **profile** you can use.|