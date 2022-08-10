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
<tr>
<td> <b>Positional</b> args </td> 
<td>

```Rust
println!("{0} and {1}.", a, b);
```

</td>
</tr>
</table>


