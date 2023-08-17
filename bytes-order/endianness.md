# Endianness 
Every multibyte entity has at least:
- **MSB** (Most Significant Byte);
- **LSB** (Least Significant Byte);

<br>

**Endianness** is convention about how **MSB** and **LSB** are mapped to memory addresses:
- **little-endian**: **LSB** is placed at **lowest** address, **MSB** is placed at **highest** address;
- **big-endian**: **LSB** is placed at **highest** address, **MSB** is placed at **lowest** address;

<br>

**TCP/IP** uses **big-endian**, that's why **big-endian** is also called **network byte order**.<br>
POSIX defines following functions for converting between **network byte order** and **host order** (it can be **little-endian** or **big-endian**):
- `htonl()`;
- `htons()`;
- `ntohl()`;
- `ntohs() `;

<br>

`hton` means **host to network**.
`ntoh` means **network to host**.
`s` means **short**.
`l` means **long**.

<br>

`itoa()` converts **integer** to **string literal** accordig to the rules of positional notation.

```c
#include <string.h>

void reverse(char s[]) {
    int i, j;
    char c;
 
    for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}


void itoa(int n, char s[], int radix) {
     int i, sign;
 
     if ((sign = n) < 0)
         n = -n;
     i = 0;
     do {
         s[i++] = n % radix + '0';
     } while ((n /= radix) > 0);
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
}

int main (void) {
  int i;
  unsigned char buf[1024];
  unsigned int n = 513;
  unsigned int *ptr_i;

  itoa(n, buf, 10);
  printf("itoa(n=513, buf, 10) --> %s.\n", buf);

  itoa(n, buf, 16);
  printf("itoa(n=513, buf, 16) --> %s.\n", buf);
}
```