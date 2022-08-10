# ``&str``
``&str`` type is **string literal**.

- String literals are **slices**.
- String literals are **immutable**.

<br>

## Examples
```Rust
let s: &str = "ABC";
```

<br>

# ``String``
String type represents changable at runtime string.

<br>

## Examples
```Rust
let s: String = String::new();
```

<br>

String object can be instantiated from ``&str``:
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
