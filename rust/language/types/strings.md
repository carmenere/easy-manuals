# Strings
A **string** is a sequence of ``Unicode`` scalar values encoded as a stream of ``UTF-8`` bytes.<br>

Rust has two main types of strings: ``&str`` and ``String``.

# ``&str``
The ``&str`` type is called **string literal** or **string slice**.<br>
*Strings* of ``&str`` type are statically allocated, i.e., they are hardcoded into binary and exists while programme is running.<br>
*Strings* of ``&str`` type have a **fixed-size**, and **cannot be mutated**, i.e., they are **immutable**.<br>

### Examples
```Rust
let s: &str = "ABC";
```

<br>

# ``String``
The ``String`` is provided by Rust's standard library and represent sequence of ``Unicode`` scalar that can **mutate** *at runtime*.

### Examples
- Instantiating ``String`` variables from ``String`` **constructor** (``new()``):
```Rust
let s: String = String::new();
```

- Instantiating ``String`` variables from ``&str``:
```Rust
let s1: String = String::from("ABC");
```
```Rust
let s2: String = "ABC".to_string();
```

<br>

## Methods
|Method|Description|
|:-----|:----------|
|``.len()``||
|``.push('c')``|**Append** *one character* to string.|
|``.push_str("abc")``|**Append** *substring* to string.|
|``.replace(from, to)``|**Replace** *substring* ``from`` to substring ``to``.|
|``.split()``||
