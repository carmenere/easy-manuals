# Dump vars from shell to .env file
```bash
env | sort > /tmp/.env
```

<br>

# Load vars to shell from .env file
```bash
source <(awk -F'=' '{printf "export %s=\"%s\"\n", $1, $2}' /tmp/.env)
```