# 1. From HEX to DECIMAL
```bash
customer_id='customer_id-39C11134FE816004'
customer_id_dec=$(printf "%d" 0x$(echo ${customer_id} | awk -F"-" '{print $2}'))
echo $customer_id_dec
```

<br>

# 2. From DECIMAL to HEX
```bash
customer_id_dec='52897027310'
customer_id=customer_id-$(printf "%x" $(echo ${customer_id_dec}) | tr '[:lower:]' '[:upper:]')
echo $customer_id
```
