# Example: forward data from UDS to UDP
```bash
LOG_SERVER=192.168.88.200
```

<br>

## Forwarder UDS -> UDP daemon: `nc pipe`
```bash
nc -klU /tmp/nc.sock | nc -4u ${LOG_SERVER} 514
```

<br>

## Forwarder UDS -> UDP daemon: `socat`
```bash
socat -d UNIX-LISTEN:/tmp/socat.sock,fork UDP4:${LOG_SERVER}:514
```

<br>

## Syslog server emulator
```bash
nc -4klu ${LOG_SERVER} 514 >/tmp/data
```

<br>

## Generating data to be sent
```bash
rm -f /tmp/data_to_be_sent
dd if=/dev/zero count=1000000 of=/tmp/data_to_be_sent bs=4k
```

<br>

## Send data through `nc pipe`:
```bash
time nc -N -U /tmp/nc.sock </tmp/data_to_be_sent
ls -hal /tmp/data
```

<br>

## Send data through `socat`:
```bash
time nc -N -U /tmp/socat.sock </tmp/data_to_be_sent
ls -hal /tmp/data
```
