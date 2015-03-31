+++
Categories = ["Development", "c"]
Description = ""
Tags = ["Development", "c"]
date = "2012-12-03T11:40:51-04:00"
title = "Libpq: PQexec Timeout"

+++

### 1. Establish the connection

``` c
PGconn *pg_conn = PQconnect("info");

// error check
if (PQstatus(pg_conn) != CONNECTION_OK) throw "invalid connection";
```

### 2. Grab the socket file descriptor

``` c
int socket_fd = PQsocket(pg_conn);

// error check
if (socket_fd < 0) throw "invalid socket";
```

### 3. Set the timeout

``` c
// 5 second timeout
struct timeval timeout = { 5, 0 };

// recv timeout
int setopt_result_1 = setsockopt(
    socket_fd,
    SOL_SOCKET,
    SO_RCVTIMEO,
    (char *)&timeout,
    sizeof(timeout)
);

// send timeout
int setopt_result_2 = setsockopt(
    socket_fd,
    SOL_SOCKET,
    SO_SNDTIMEO,
    (char *)&timeout,
    sizeof(timeout)
);

// error check
if (setopt_result_1 < 0 || setopt_result_2 < 0) throw "failed to set timeout";
```

