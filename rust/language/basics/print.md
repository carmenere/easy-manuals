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

<br>
Mapping foramatting sign to formatting trait:

<br>
<ul>
<li><i>nothing</i> ⇒ <code>Display</code> trait</li>
<li><code>:?</code> ⇒ <code>Debug</code> trait</li>
<li><code>:x?</code> ⇒ <code>Debug</code> with lower-case hexadecimal integers</li>
<li><code>:X?</code> ⇒ <code>Debug</code> with upper-case hexadecimal integers</li>
<li><code>:o</code> ⇒ <code>Octal</code></li>
<li><code>:x</code> ⇒ <code>LowerHex</code></li>
<li><code>:X</code> ⇒ <code>UpperHex</code></li>
<li><code>:p</code> ⇒ <code>Pointer</code></li>
<li><code>:b</code> ⇒ <code>Binary</code></li>
<li><code>:e</code> ⇒ <code>LowerExp</code></li>
<li><code>:E</code> ⇒ <code>UpperExp</code></li>
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


