# Coercions
**Coercions** (/kəʊˈɜːrʒnz/ or /kəʊˈɜːʃnz/) are **implicit** type conversions.

<br>

# Dereferenceable types
What types can be **dereferenced**?
A type can be **dereferenced** if it **reference** type.<br>
Non-pointer types like ``bool`` or ``char`` or ``(u8, u8)`` **cannot** be **dereferenced**: they **don't** implement the ``Deref`` trait and **don't** act like pointers to some other type.<br>

```Rust
fn foo(b: &bool) -> bool { *b }
```

All **dereferenceable types** implement the ``Deref`` and/or ``DerefMut`` traits, and can be **dereferenced** with the ``*`` operator.<br>

<br>

# ``Deref`` trait
Path to ``Deref`` trait is ``std::ops::Deref``.

```Rust
pub trait Deref {
    type Target: ?Sized;

    fn deref(&self) -> &Self::Target;
}
```

``deref`` method returns a **reference** to the value we want to access with the ``*`` operator.<br>
Without the ``Deref`` trait, the compiler can only **dereference** ``& references``.<br>
The ``deref`` method gives the compiler the ability to take a value of any type that implements ``Deref`` and call the ``deref`` method to get a ``& reference`` that it knows how to dereference.

When we type ``*y`` in our code, behind the scenes Rust actually converts it to: ``*(y.deref())``.<br>

Rust substitutes the ``*`` operator with a call to the ``deref`` method and then a plain dereference so we don’t have to think about whether or not we need to call the ``deref`` method. 

<br>

# Deref coercion
**Deref coercion** converts a *reference* to a **type** that implements the ``Deref`` trait into a *reference* to **another type**.
For example, **deref coercion** can convert ``&String`` to ``&str`` because ``String`` implements the ``Deref`` trait such that it returns ``&str``.

To see **deref coercion** in action, consider following function that has the parameter name of type ``&str``:
```Rust
fn hello(name: &str) {
    println!("Hello, {name}!");
}
```

This ``hello`` function receives a **string slice** as an **argument**, such as ``hello("Rust");``.<br>
**Deref coercion** makes it possible to call ``hello`` with a **reference** to a value of type ``MyBox<String>``:

```Rust
fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&m);
}
```

Here we’re calling the ``hello`` function with the argument ``&m``, which is a **reference** to a ``MyBox<String>`` value.<br>
Because we implemented the ``Deref`` trait on ``MyBox<T>``, Rust can turn ``&MyBox<String>`` into ``&String`` by calling ``deref`` method.<br>
The standard library provides an implementation of ``Deref`` on ``String`` that returns a ``string slice``, and this is in the API documentation for ``Deref``.<br>
Rust calls ``deref`` again to turn the ``&String`` into ``&str``, which matches the ``hello`` function’s definition.<br>

<br>

# How Deref coercion interacts with mutability

Similar to how you use the ``Deref`` trait to override the ``*`` operator on **immutable** **references**, you can use the ``DerefMut`` trait to override the ``*`` operator on **mutable** **references**.

Rust does **deref coercion** when it finds types and trait implementations in three cases:
- from ``&T``     to ``&U``    if ``T: Deref<Target=U>``;
- from ``&mut T`` to ``&mut U`` if ``T: DerefMut<Target=U>``;
- from ``&mut T`` to ``&U``     if ``T: Deref<Target=U>``.

<br>

The first case states that if you have a ``&T``, and ``T`` implements ``Deref`` to some type ``U``, you can get a ``&U`` **transparently**.<br>
The second case states that if you have a ``&mut T``, and ``T`` implements ``DerefMut`` to some type ``U``, you can get a ``&mut U`` **transparently**.<br>
The third case states that if you have a ``&mut T``, and ``T`` implements ``Deref`` to some type ``U``, you can get a ``&U``. Rust will also coerce a **mutable** reference to an **immutable** one.

<br>

# Dot ``.`` operator
When you use dot operator ``.``, the compiler will insert as many ``*`` (dereferencing operations) as necessary to find the appropriate method. As **this happens** **at compile tim**e, there is **no** **runtime cost** of finding the method.

For example, if ``x`` has type ``&i32``, then writing ``x.count_ones()`` is shorthand for ``(*x).count_ones()``, because the ``count_ones`` method requires an ``i32``.

<br>

# Examples
```Rust
fn foo(a: &[i32]) {
    // code
}

fn bar(s: &str) {
    // code
}

let v = vec![1, 2, 3];
// &Vec<i32> coerces into &[i32] because Vec<T> impls Deref<Target=[T]>
foo(&v); 

let s = "Hello world".to_string();
let rc = Rc::new(s);
// Rc<T> impls Deref<Target=T> and &Rc<String> coerces into &String 
// which coerces into &str. This happens as much as needed at compile time.
bar(&rc);
```