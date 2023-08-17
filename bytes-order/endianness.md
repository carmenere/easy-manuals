# Endianness 
Every multibyte entity has at least:
- **MSB** (Most Significant Byte);
- **LSB** (Least Significant Byte);

<br>

**Endianness** is convention about MSB and LSB in memory:
- **little-endian**: **LSB** is placed at **lowest** address, **MSB** is placed at **highest** address;
- **big-endian**: **LSB** is placed at **highest** address, **MSB** is placed at **lowest** address;

<br>

**TCP/IP** uses **big-endian**, that's why **big-endian** is also called **network byte order**.