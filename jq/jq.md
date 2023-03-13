# `jq`

### Example: print json as is
`.` is refered to whole JSON object:
```bash
echo '{"some_field": {"some_list": [{"name": "foo", "id": 33}]}}' | jq '.'
{
  "some_field": {
    "some_list": [
      {
        "name": "foo",
        "id": 33
      }
    ]
  }
}
```

<br>

### Example: get foo's id
```bash
echo '{
    "some_field": {
        "some_list": [
            {"name": "foo", "id": 33}
        ]
    }
}' | jq '.some_field.some_list[] | select (.name == "foo") | .id'
33
```

<br>

```bash
echo '{
    "some_field": {
        "some_list": [
            {"name": "foo", "id": 33},
            {"name": "bar", "id": 34},
            {"name": "baz", "id": 35}
        ]
    }
}' | jq '.some_field.some_list[] | select (.name == "baz" or .name == "bar") | .id'
34
35
```

<br>

```bash
echo '{
    "some_field": {
        "some_list": [
            {"name": "foo", "id": 33, "color": 1},
            {"name": "bar", "id": 34, "color": 2},
            {"name": "baz", "id": 35, "color": 3}
        ]
    }
}' | jq '.some_field.some_list[] | select (.name == "baz" and .color == 3) | .id'
35
```
