println!
Positional args	println!("{0} and {1}.", a, b);
Named args	println!("{a} and {b}.", a="x", b="y");
Expressions	println!("a + b = {}.", 50 + 40);
Explicit values	println!("{} and {}.", "x", 22);
Printing traits	Println!("binary: {:b}.", 12);
Debug trait	println!("Array: {:?}", [1, 2]);

# Formatted print
There are series of macros defined in ``std::fmt`` for printing:
|Macros|Description|
|:-----|:----------|
|``print!``|Writes text to the **standard output**: ``io::stdout``.|
|``println!``|Same as ``print!`` but **appends newline** ``\n``.|
|``eprint!``|Writes text to the **standard error**: ``io::stderr``.|
|``eprintln!``|Same as ``eprint!`` but **appends newline** ``\n``.|

<br>

# Variants to pass arguments to ``println!``
<table>
<tr>
<td> <b>Variant</b> </td> <td> <b>Example</b> </td>
</tr>
<tr></tr>
<tr>
<td> <b>Positional args</b> </td> 
<td>

```Rust
println!("{0} and {1}.", a, b);
```

</td>
</tr>
<tr></tr>
<tr>
<td><b>Named args</b></td>
<td>

```Rust
println!("{a} and {b}.", a="x", b="y");
```

</td>
</tr>
<tr></tr>
<tr>
<td><b>Expressions</b></td>
<td>

```Rust
println!("a + b = {}.", 50 + 40);
```

</td>
</tr>
<tr></tr>
<tr>
<td><b>Explicit values</b></td>
<td>

```Rust
println!("{} and {}.", "x", 22);
```

</td>
</tr>
<tr></tr>
<tr>
<td><b>Formatting traits</b>.

Mapping foramatting sign to formatting trait:
<ul>
<li>
<i>nothing</i> ⇒ <code>Display</code> trait</li>
<li>

<code>:?</code> ⇒ ``Debug`` trait</li>
<li>

<code>:x?</code> ⇒ `Debug` with lower-case hexadecimal integers</li>
<li>

``:X?`` ⇒ `Debug` with upper-case hexadecimal integers</li>
<li>

``:o`` ⇒ `Octal`</li>
<li>

``:x`` ⇒ ``LowerHex``</li>
<li>

``:X`` ⇒ ``UpperHex``</li>
<li>

``:p`` ⇒ ``Pointer``</li>
<li>

``:b`` ⇒ ``Binary``</li>
<li>

``:e`` ⇒ ``LowerExp``</li>
<li>

``:E`` ⇒ ``UpperExp``</li>
</ul>
</td>
<td>

```Rust
println!("binary: {:b}.", 12);
```

</td>
</tr>
<tr></tr>
<tr>
<td><b>Debug trait </b>

</td>
<td>

```Rust
println!("Array: {:?}", [1, 2]);
```

</td>
</tr>
</table>


