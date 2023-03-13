# CLI options
|Option|Description|
|:-----|:----------|
|`-H`|**Adds** HTTP **header**.|
|`-s`|**Hides** the **progress** and **errors**|
|`-S`|Tells `curl` to be silent, except when there is an error, i.e., it shows the error message hidden by `-s`.<br>This is useful when you want curl to be silent but still want to know why it failed.|
|`-f`|By default, if server responds with **error**, `curl` will output response and return **exit code** `0`.<br>`-f` causes `curl` to exit with **exit code** `22` when **HTTP response code** is **>=400** and to prevent `curl` from outputting server's response.|
|`--fail-with-body`|`--fail-with-body` is like `-f` but **allows** `curl` to output server's response.|
|`-k`|`curl` performs SSL certificate verification by default.<br>`-k` **turns off** curl's verification of the certificate.|
|`-L`|By default, `curl` does not follow redirects.<br>`-L` **force** `curl` to **follow redirects**.|
|`--max-redirs`|**Limits** the number of following redirects.|
|`-w`|Defines what to display on stdout after a **completed** and **successful** operation.|
|`-d`|Sends specified data as body in a POST request.|
|`-v`|Verbose output.|
|`-D <path_to_file>`|Dump **headers** to file `<path_to_file>`.|

<br>

## Exmples
### `Content-type` header 
```bash
curl -X GET -H 'Content-type: application/json' http://localhost:8081/
```

<br>

### To force curl not send 'Expect' header
`curl` sometimes automatically adds an `Expect: 100-continue` header.<br>
To force `curl` not send 'Expect' header add `-H 'Expect:'`:
```bash
curl -X GET -H 'Expect:' http://localhost:8081/
```

<br>

### Send data in POST
```bash
curl -X POST https://example.com -d '{"name": "foo"}'
curl -X POST https://example.com -d @path_to_file_with_body
```

<br>

### Print `http_code`
```bash
curl ... -o /dev/stderr -w "%{http_code}
```

<br>

### Compare `http_code` with `200`
```bash
[ $(curl ... -o /dev/stderr -w "%{http_code}") -eq 200 ]
```

<br>

# `Expect` header and `100 Continue` status
To force a server check the request's headers **before** sending body, a client must send `Expect: 100-continue` as a header in its initial request.<br>

The server responds on `-H 'Expect: 100-continue'` with:
- `100` (**Continue**) indicates that everything so far is OK and that the client should continue with the request or ignore it if it is already finished.
- `417` (**Expectation Failed**) indicates that server cannot receive data, for example, the server may reject a request if its `Content-Length` is **too large**.

<br>

No common browsers send the `Expect` header, but some other clients such as `curl` do so by default.

<br>

# Time measurements
There are **some vriables** for `-w` option to **estimate time**:
|Variable|Meaning|
|:-------|:------|
|`time_namelookup`|The time, in seconds, it took *from* the **start** *until* the **name resolving** was **completed**.|
|`time_connect`|The time, in seconds, it took *from* the **start** *until* the TCP connect to the remote host was **completed**.|
|`time_appconnect`|The time, in seconds, it took *from* the **start** *until* the SSL/SSH handshake to the remote host was **completed**. Only for SSL/SSH requests.|
|`time_pretransfer`|The time, in seconds, it took *from* **start** *until* **first byte** of *request* was **sent**.|
|`time_redirect`|The time, in seconds, it took for **all redirection steps** include **name lookup**, **connect**, **pretransfer** and **transfer**. `time_redirect` shows the complete execution time for multiple redirections.|
|`time_starttransfer`|The time, in seconds, it took  *from* the **start** *until* the **first byte** of *response* was **read**.|
|`time_total`|The **total time**, in seconds, that the **full operation lasted**. The time will be displayed with millisecond resolution.|

<br>

> **Note**:<br>
> `time_starttransfer` - `time_pretransfer` is the **time of generating response on server side, including RTT**.<br>
> `time_total` - `time_starttransfer` is the time of **data transferring** from server, i.e., from the **first byte** of *response* was **read** until `FIN` was sent by client.

<br>

#### Example
```bash
ESTIMATIONS='{
"time_namelookup": %{time_namelookup},
"time_connect": %{time_connect},
"time_appconnect": %{time_appconnect},
"time_pretransfer": %{time_pretransfer},
"time_redirect": %{time_redirect},
"time_starttransfer": %{time_starttransfer},
"time_total": %{time_total}
}\n'

curl -v -w "$ESTIMATIONS" -X GET  https://nginx.org
{
"time_namelookup": 0.009125,
"time_connect": 0.060199,
"time_appconnect": 0.158548,
"time_pretransfer": 0.158631,
"time_redirect": 0.000000,
"time_starttransfer": 0.212673,
"time_total": 0.213099
}

# Other estimations
DNS_LOOKUP = time_namelookup = 9 ms
TCP_HANDSHAKE = time_connect - time_namelookup =  60 - 9 = 51 ms
SSL_HANDSHAKE = time_appconnect - time_connect = 158 - 60 = 98 ms
PREPARE_REQUEST = time_pretransfer - time_appconnect = 158.631 - 158.548 = 0.083 ms
PREPARE_RESPONSE = time_starttransfer - time_pretransfer =  212 - 158 = 54 ms
DATA_TRANSFERRING = time_total - time_starttransfer = 213.099 - 212.673 = 0.43 ms
```
