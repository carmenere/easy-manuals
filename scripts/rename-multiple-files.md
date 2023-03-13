# 
```bash
CMD='mv'
for file in $(find . -regex '.*\.up\.sql'); do "${CMD}" $file $(echo $file | sed "s/\(\.up\)//"); done
```
