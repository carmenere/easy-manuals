# On ``server`` side
1. **Check**: 
```bash
grep 'AllowAgentForwarding' /etc/ssh/sshd_config
```

<br>

2. Enable **AgentForwarding**: set ``AllowAgentForwarding`` to ``yes``:
- if it is **commented** and **yes**:
```bash
sudo sed -i 's/^#AllowAgentForwarding\s\+yes\s*$/AllowAgentForwarding yes/' /etc/ssh/sshd_config
```
- **or** if it is **commented** and **no**:
```bash
sudo sed -i 's/^#AllowAgentForwarding\s\+no\s*$/AllowAgentForwarding yes/' /etc/ssh/sshd_config
```
- **or** if it is **UNcommented** and **no**:
```bash
sudo sed -i 's/^AllowAgentForwarding\s\+no\s*$/AllowAgentForwarding yes/' /etc/ssh/sshd_config
```

<br>

3. **Check**: 
```bash
grep 'AllowAgentForwarding' /etc/ssh/sshd_config
```

<br>

4. **Restart** `ssh`:
```bash
sudo systemctl restart ssh
```

<br>

# On ``client`` side
1. Add to your ``~/.ssh/config`` file
```bash
Host [host address]
    ForwardAgent yes
```
where ``host address`` is the address of the host you want to allow creds to be forwarded to.

2. Add (**every time** you got bash session) the key you want forwarded to the ssh agent:<br>
   a) To add **all keys** run: ``ssh-add`` <br>
   b) To add **specific key** run: ``ssh-add ~/.ssh/id_ed25519`` <br>

3. Log into the **remote** host:
```bash
ssh -A [user]@[hostname]
```

4. From here, if you log into **another host** *that accepts that key*, it will just work:
```bash
ssh [user]@[hostname]
```
