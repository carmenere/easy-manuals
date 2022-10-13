# Ownership

<br>

## Basic terms
|Term|Meaning|
|:---|:------|
|**Type**|Is a *set of* 1) **allowed values**; 2) **memory layout** for values; 3) **allowed operations** for values.|
|**Owner**|Identifier that is owning value.|
|**Bind**|Associate identifier with a value.|
|**Copy**|Associate identifier with **bitwise copied** value and **keep the original identifier valid**.|
|**Move**|Associate identifier with **bitwise copied** value and **invalidate the original identifier**.|
|**Clone**|Associate identifier with **completely independed duplicate** of value and **keep the original identifier valid**.|
|**Mutate**|Change the value associated with a mutable identifier. By default, Rust data is immutable - it can't be changed.|
|**Borrow**|The **action of creating a reference**. Reference is a named pointer to some value.|

<br>

## Variable scope
**Scope** (or **variable scope**) is the **range** within a program for which a variable is **valid**.<br>
In Rust scope has **explicit boundaries**: **opening** curly bracket ``{`` and **closing** curly bracket ``}``.<br>
In Rust variable is valid from the point at which it was declared by ``let`` keyword until the **end of scope**: closing curly bracket ``}``.<br>
**Variable** or **variable’s identifier** or **identifier** are the synonyms.<br>

```Rust
{ // Scope has started
    // s is not valid here, it’s not yet declared
    let s = "hello";   // s is valid from this point
    // ...
} // Scope is over, and s is no longer valid
```

## Ownership rules
**Ownership** enables Rust to make **memory safety guarantees** without needing GC.

Ownership rules:
1. **Each value** in Rust **has** an **identifier** that’s called its **owner**.
2. There can only be **one owner at a time**.
3. When the **owner** goes **out of scope**, the **value** will be **dropped**, (**scope based resource management**).

In C++ this **pattern of deallocating resources at the end of variable lifetime** is called **RAII**.  Doing this correctly without GC is a difficult problem.


## Blittable and Non-blittable types
**Completely independent copy** of object is such copy that can be safely used separately to the origin one.<br>

Types of copying:
- **Bitwise copy** (aka **shallow copy**/**bit block transfer**) **type-independed logic** to duplicate values and implemented in syscall ``memcpy()``, in other words, **bitwise copy** copies contiguous block of memory bit-by-bit (byte-by-byte) to another location.
- **Semantic copy** (aka **deep copy**) requires **type-specific logic** to duplicate values safely.

**bitblt**/**bit blit**/**blit** are contractions for **bit block transfer**.

|Type|Layout in memory|Type of copying|
|:---|:---------------|:---|
|**Blittable type**|Object of blittable type occupies exactly one contiguous /kəntɪgjuəs/ block of memory.|**Bitwise copy** *can* create completely independent copy of object of blittable type.|
|**Non-blittable type**|Object of non-blittable type occupies more than one not adjacent contiguous /kəntɪgjuəs/ blocks of memory.|**Bitwise copy** *cannot* create completely independent copy of object of non-blittable type. To create completely independent copy of object of non-blittable type **semantic copy** must be used.|

