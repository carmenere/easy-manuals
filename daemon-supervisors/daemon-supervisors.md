# Commands
## `ps`
- `ps -eo user,sid,ppid,pid,args f`
- `ps -eo user,sid,ppid,pid,args f | grep 'nginx\|USER\|init\|supervisord\|svscanboot\|svscan\|supervise'`

<br>

## List all TCP listening sockets
- `ss -natlp`

<br>

## `nginx` error logs
- `:> /var/log/nginx/error.log`
- `cat /var/log/nginx/error.log`

<br>

# Daemon supervisors
Thre are many various **daemon supervisors**:
- **supervisor** is a tool for managing UNIX services.
- **supervise-daemon** is OpenRC's daemon supervisor.
- **daemontools** is a collection of tools for managing UNIX services. `supervise` **starts** and **monitors** a service.

<br>

## Limitations
Limitations of daemon supervisors:
1. Programs meant to be run under **daemon supervisor** (`daemontools`, `supervisor` or `supervise-daemon`) should **not** daemonize themselves.
2. Instead, they **should run** in the **foreground**.<br>
3. They should **not** detach from the terminal from which they are started.

<br>

## Tree of processes
### Example1: `daemontools`
```bash
USER         SID    PPID     PID COMMAND
root           1       0       1 /sbin/init
root        7218       1    7218 /bin/sh /usr/bin/svscanboot /etc/service/
root        7218    7218    7220  \_ svscan /etc/service
root        7218    7220    7222  |   \_ supervise ngx
root        7218    7222    7223  |       \_ nginx: master process /usr/sbin/nginx -g daemon off;
www-data    7218    7223    7224  |           \_ nginx: worker process
www-data    7218    7223    7225  |           \_ nginx: worker process
```

<br>

### Example2: `supervisor`
```bash
USER         SID    PPID     PID COMMAND
root           1       0       1 /sbin/init
root        7263       1    7263 /usr/bin/python3 /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
root        7263    7263    7264  \_ nginx: master process /usr/sbin/nginx -g daemon off;
www-data    7263    7264    7265      \_ nginx: worker process
www-data    7263    7264    7266      \_ nginx: worker process
```

<br>

# Supervisor
## Installation
```bash
sudo apt update
sudo apt install supervisor
sudo systemctl enable supervisor --now
sudo systemctl status supervisor
```

<br>

### `systemctl`
1. **Restart** `supervisor`:
- `systemctl restart supervisor`
1. **Stop** `supervisor`:
- `systemctl stop supervisor`
1. **Start** `supervisor`:
- `systemctl start supervisor`
4. **Status**:
- `systemctl status supervisor`
  
<br>

## Create new service
`supervisor` searches for daemon configs here `/etc/supervisor/conf.d/`.<br>

Every **section** `[program:name]` defines separate daemon settings:
```toml
[program:%name%]
key=value
```

<br>

Minimal set of keys for daemon:
- `directory` - working dir;
- `command` - path to binary;
- `user` - the user under whose name the process is launched;
- `autostart`
- `autorestart`

<br>

### Example: nginx
1. Run`sudo vi /etc/supervisor/conf.d/ngx.conf`.
2. Paste folowing snippet:
```toml
[program:ngx]
directory=/tmp
command=/usr/sbin/nginx -g 'daemon off;'
user=root
autostart=true
autorestart=true
```

<br>

## Statuses
- `supervisorctl status`
- `supervisorctl status ngx`

<br>

## Start/Stop/Restart
- `supervisorctl start ngx`
- `supervisorctl stop ngx`

<br>

# Daemontools
## Installation
```bash
sudo apt update
apt install daemontools daemontools-run
sudo systemctl enable daemontools-run --now
sudo systemctl status daemontools-run
```

<br>

### `systemctl`
1. **Restart** `daemontools-run`:
- `systemctl restart daemontools-run`
1. **Stop** `daemontools-run`:
- `systemctl stop daemontools-run`
1. **Start** `daemontools-run`:
- `systemctl start daemontools-run`
4. **Status**:
- `systemctl status daemontools-run`

<br>

## Create new service
### Example: nginx
1. Create dir with name of service: `sudo mkdir /etc/service/ngx`
2. Run `sudo vi /etc/service/ngx/run` and paste folowing snippet:
```bash
#!/bin/bash
exec /usr/sbin/nginx -g 'daemon off;'
```
3. Change permissions:
`sudo chmod u+x /etc/service/ngx/run`

<br>

## Statuses
`svstat /etc/service/ngx` check **status** of service.

<br>

## Start/Stop/Restart
`svc` options:
- `-u` **Up**. If the service is not running, start it. If the service stops, restart it.
- `-d` **Down**. If the service is running, send it a `TERM` signal and then a `CONT` signal. After it stops, do not restart it.
- `-o` **Once**. If the service is not running, start it. Do not restart it if it stops.
- `-p` **Pause**. Send the service a `STOP` signal.
- `-c` **Continue**. Send the service a `CONT` signal.
- `-h` **Hangup**. Send the service a `HUP` signal.
- `-a` **Alarm**. Send the service an `ALRM` signal.
- `-i` **Interrupt**. Send the service an `INT` signal.
- `-t` **Terminate**. Send the service a `TERM` signal.
- `-k` **Kill**. Send the service a `KILL` signal.
- `-x` **Exit**. supervise will exit as soon as the service is down. If you use this option on a stable system, you're doing something wrong; supervise is designed to run forever.

<br>

Examples:
- `svc -u /etc/service/ngx` **start** service
- `svc -d /etc/service/ngx` **stop** service
