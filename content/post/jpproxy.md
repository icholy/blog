+++
Categories = ["Development", "PHP", "JavaScript"]
Description = ""
Tags = ["Development", "php", "javascript"]
date = "2011-07-15T12:43:11-04:00"
title = "JPProxy - tiny jsonp proxy"

+++

JPProxy is a very simple yet powerful JSONP script.
It allows you to make ajax like requests to any page on a server that has the jpproxy.php script on it.
I tried really hard to make it as simple and generic as possible so the source is tiny.

### 1. Client

A script tag is injected into the DOM and all the values are added to the url as GET parameters.

* `callback_id`: this gets sent back in the generated javascript to execute the correct callback
* `page`: the page to retrieve
* `data`: request parameters in json   

``` html
<script type='text/javascript' src='http://server/jpproxy.php?callback_id=1&page=somepage.php&data={"key":"value"}'>
```

### 2. Server

The `$_GET["data"]` key/value pairs are assigned to `$_GET` and `$_POST` variables.
Then the requested page is included as a script so it can use the GET and POST paramters the way it normaly would.
Finally javascript is generated which passes the `callback_id` and result data to the callback function


``` php
<?php
  echo "JPProxy.callback(" . $_GET["callback_id"] .",$result);";
?>
```

### 3. Client

The generated javascript get's executed and your callback function is called with the response data.

**Senario:**

we have a page on http://server1.com and we want the page to grab http://server2.com/path/data.php

Drop jpproxy.php in the root directory ( http://server2.com/jpproxy.php )

**Example Client Code:**

``` js
//callback to handle the data once it arrives
function mycallback(data){
    console.log(data);
}

//POST and GET parameter passed to data.php
var parameters = {
    foo: "bar",
    bar: "poop",
}

//set the proxy location
JPProxy.setProxy("http://server2.com/jpproxy.php");

//note: the page's path must be relative to jpproxy.php
JPProxy.post("path/data.php", parameters, mycallback);
```

### Source:

**jpproxy.js**

``` js
var JPProxy = {
    request_id: 0,
    callbacks: [],
    scripts: [],
    proxy: null,
    setProxy: function(proxy){
        this.proxy = proxy;
    },
    callback: function(id,data){
        this.callbacks[id](data);
        document.body.removeChild(this.scripts[id]);
        delete this.callbacks[id];
        delete this.scripts[id];
    },
    get: function(page,data,callback){
        this.callbacks[++this.request_id] = callback;
        var script = document.createElement('script');
        var src = this.proxy + '?page=' + encodeURIComponent(page) + '&callback_id=';
        src += this.request_id.toString() + '&data=' + encodeURIComponent(JSON.stringify(data));
        script.setAttribute('type', 'text/javascript');
        script.setAttribute('src',src)
        this.scripts[this.request_id] = script;
        document.body.appendChild(script);
    }
};
```

**jpproxy.php**

``` php
<?php
ob_start();
$data = json_decode($_GET["data"]);
$obj = "null";
if ($data && is_object($data) && is_file($_GET["page"])) {
    foreach ($data as $key => $value) { $_GET[$key] => $_POST[$key] = $value; }
    require $_GET["page"];
    $obj = json_encode(ob_get_clean());
}
echo "JPProxy.callback(" . $_GET["callback_id"] . ", $obj);";
?>
```
