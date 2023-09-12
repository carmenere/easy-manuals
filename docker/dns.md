# DNS
By default, containers **inherit the DNS settings of the host**, as defined in the `/etc/resolv.conf` configuration file.<br>
- containers that attach to the **default** bridge receive a copy of this file;
- containers that attach to a **custom** bridge use **Docker's embedded DNS server**; the **embedded DNS server** forwards external DNS lookups to the DNS servers configured on the host.

The `docker run`/`docker create` flags related to DNS configuration:
|Flag|Description|
|:---|:----------|
|`--dns`|The **IP address** of a **DNS server**. To specify **multiple** DNS servers, use **multiple** `--dns` flags. If the container **can't reach** any of the IP addresses you specify, it uses **Google's public DNS** server at `8.8.8.8`.|
 

