+++
Description = ""
Tags = ["Development", "aws", "x-ray", "debugging"]
Categories = ["Development", "GoLang"]
date = "2023-01-17T12:44:05-05:00"
title = "AWS X-Ray: Force Sample"

+++

### Background

At my current workplace, we use X-Ray configured with a sample rate of 0.01.
This means that a random 1% of requests will be traced.
The low rate is great at keeping costs down, but it's not useful for debugging specific failed requests.
Fortunately, you can force X-Ray to sample your request by generating a trace id, and setting the `X-Amzn-Trace-Id` header.

### Generating trace IDs

The id format is documented [here](https://docs.aws.amazon.com/jjxray/latest/devguide/xray-api-sendingdata.html#xray-api-traceids)
along with a Python code sample.

> A trace_id consists of three numbers separated by hyphens. For example, `1-58406520-a006649127e371903a2de979`. This includes:
> 
> * The version number, that is, 1.
> * The time of the original request, in Unix epoch time, in 8 hexadecimal digits.
> * For example, 10:00AM December 1st, 2016 PST in epoch time is 1480615200 seconds, or 58406520 in hexadecimal digits.
> * A 96-bit identifier for the trace, globally unique, in 24 hexadecimal digits.

Python Implementation:

``` python
import time
import os
import binascii

def create_trace_id():
	START_TIME = time.time()
	timestamp = hex(int(time.time()))[2:]
	random = binascii.hexlify(os.urandom(12)).decode('utf-8')
	return "1-{}-{}".format(timestamp, random)
```

Node.js Implementation:

``` js
import { randomBytes } from 'crypto';

export function createTraceID(): string {
	const timestamp = Math.floor(Date.now() / 1000).toString(16);
	const random = randomBytes(12).toString('hex');
	return `1-${timestamp}-${random}`;
}
```

Go Implementation:

``` go
package main

import (
	"crypto/rand"
	"fmt"
	"time"
)

func CreateTraceID() string {
	var id [12]byte
	rand.Read(id[:])
	return fmt.Sprintf("1-%08x-%x", time.Now().Unix(), id)
}
```

### Making HTTP requests with the trace ID

The trace id is passed via the `X-Amzn-Trace-Id` header using the following format:

```
X-Amzn-Trace-Id: Root=<trace-id>;Parent=<span-id>;Sampled=<1 or 0>
```
* `Root` is the trace ID.
* `Parent` is the parent span ID (this may be omitted).
* `Sampled` is a flag to indicate if this request is sampled.

As you've probably inferred, setting `Sampled=1` will instruct X-Ray to sample the request.
Here's a full runnable example in Go:

``` go
package main

import (
	"crypto/rand"
	"fmt"
	"log"
	"net/http"
	"time"
)

func CreateTraceID() string {
	var id [12]byte
	rand.Read(id[:])
	return fmt.Sprintf("1-%08x-%x", time.Now().Unix(), id)
}

func main() {
	url := "https://api.company.com/v1/service"
	req, _ := http.NewRequest(http.MethodGet, url , nil)
	traceID := CreateTraceID()
	fmt.Printf("TraceID: %s\n", traceID)
	req.Header.Set(
		"X-Amzn-Trace-Id",
		fmt.Sprintf("Root=%s;Sampled=1", traceID),
	)
	_, err = http.DefaultClient.Do(req)
	if err != nil {
		log.Fatal(err)
	}
}
```

### Debugging Postman Requests

Postman has a feature called "Pre-request Scripts" which can be used to add a trace header:

``` js
const bytes = Array.from({length: 12}, () => Math.trunc(Math.random() * 255));
const random = Buffer.from(bytes).toString('hex');
const timestamp = Math.floor(Date.now() / 1000).toString(16);
const id = `1-${timestamp}-${random}`;

console.log(`Trace ID: ${id}`);

pm.request.headers.add({
    key: 'X-Amzn-Trace-Id',
    value: `Root=${id};Sampled=1`
});
```

Open the console to view the printed trace id.

### Debugging a flaky Node.js Test

Using our newly aquired information, lets see how we can use it to debug a flaky integration test that only fails in CI.

``` js
it("should create and delete a user", async () => {
	const user = await api.createUser({
		name: "Bob Marley",
		email: "bob.marley@protonmail.com",
	});
	await api.deleteUser(user.id);
});
```

Let's use the [@mswjs/interceptors](https://www.npmjs.com/package/@mswjs/interceptors) package to add trace ids to all outgoing requests.


``` js
import { BatchInterceptor } from '@mswjs/interceptors';
import nodeInterceptors from '@mswjs/interceptors/lib/presets/node';
import { randomBytes } from 'crypto';

export function createTraceID(): string {
	const timestamp = Math.floor(Date.now() / 1000).toString(16);
	const random = randomBytes(12).toString('hex');
	return `1-${timestamp}-${random}`;
}

it("should create and delete a user", async () => {
	const interceptor = new BatchInterceptor({
		name: "http intercept",
		interceptors: nodeInterceptors,
	});

	interceptor.on('request', (req) => {
		const traceID = createTraceID();
		const header = `Root=${traceID};Sampled=1`;
		req.headers.set("X-Amzn-Trace-Id", header);
		console.log("intercept", {
			method: req.method,
			url: req.url,
			traceID,
		});
	});

	interceptor.apply();

	const user = await api.createUser({ 
		name: "Bob Marley",
		email: "bob.marley@protonmail.com",
	});
	await api.deleteUser(user.id);

	interceptor.dispose();
});
```

Now it's a matter of waiting until the flaky test fails. Once that happens we'll have a corresponding trace id!

