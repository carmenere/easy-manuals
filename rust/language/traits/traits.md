# Traits
**Trait** is **functionality** that you can call **on** particular **structure**.<br>

**Trait** is *similar* to **interface** or **abstract class**.<br>

Inside trait there can be *both* **signatures** (like interface or abstract class) and **default implementations**.<br>

**Static method** – method that **doesn't** takes ``&self``.<br>
**Bound method** – method that takes ``&self`` *as first parameter*.<br>

**Constructors** are **static methods** of trait that have name ``new`` and return ``Self``.<br>

<br>

## ``impl ... for ...``
To implement trait ``SomeTrait`` for particular type `SomeStruct` there is following syntax:
```Rust
impl SomeTrait for SomeStruct {
    ...
}
```
<br>

#### Example
```Rust
struct RustDev {
    awesome: bool
}

struct JavaDev {
    awesome: bool
}

trait Developer {
    fn new(awesome: bool) -> Self;
    fn language(&self) -> &str;
    fn say_hello(&self) { println!("Hello world!") }
}

impl Developer for RustDev {
    fn new(awesome: bool) -> Self {
        RustDev { awesome: awesome }
    }

    fn language(&self) -> &str {
        // unimplemented!()
         "Rust"
    }

    fn say_hello(&self) {
        // todo!()
        println!("println!(\"Hello world!\");");
    }
}

fn main() {
    // Explicit instantiation
    // let r = RustDev { awesome: true};

    // Instantiation through type constructor
    let r = RustDev::new(true);

    println!("{}", r.language());
    r.say_hello();
}
```

<br>

## Returning traits
Rust **cannot** return trait, i.e. return type cannot have an unboxed trait object. Reason for that is the Rust memory guaranties. Rust needs to know the size of the returned value at compile time.

Solution is to return ``Box<dyn SomeTrait>``.

<br>

### Example
#### Incorrect code
```Rust
struct Dog {}
struct Cat {}

trait Animal {
    fn make_noise(&self) -> &'static str;
}

fn get_animal(rand_number: f64) -> Animal {
    if rand_number < 1.0 {
        Dog {}
    }
    else {
        Cat {}
    }
}
```

<br>

#### Working version
```Rust
fn get_animal(rand_number: f64) -> Box<dyn Animal> {
    if rand_number < 1.0 {
        Box::new(Dog {})
    }
    else {
        Box::new(Cat {})
    }
}
```