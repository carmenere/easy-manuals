# vi arrow keys broken in insert mode
My arrow keys don't work in `vi` in **insert mode** at home, they just each insert a newline and a capital letter, like 'A'. Is there a way to fix that?<br>

Run:
```bash
echo ':set nocompatible' >> ~/.vimrc
```
