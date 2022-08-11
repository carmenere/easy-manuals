# Newtype pattern
There is one case when a tuple struct is very useful, though, and that is when it has only one element. 
The ``newtype pattern`` allows to create a **new type** that is **distinct** from its contained value and also expresses its own semantic meaning.

<br>

## Syntax
```Rust
struct <MyNewTypeName>(T);
```
where ``T`` is of some type.

#### Example
```Rust
struct Foo(i32);

fn main() {
    let f = Foo(10);
    println!("Value of f: {}.", f.0);
}
```

<br>

## Destructuring let
To **extract** the **inner value** ``destructuring let`` is used.

#### Example
```Rust
struct Foo(i32);

fn main() {
    let f = Foo(10);
    let Foo(v) = f;
    println!("Value of 'v': {}.", v);
}

Output:
Value of 'v': 10.
```
