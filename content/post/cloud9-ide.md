+++
Categories = ["Development"]
Description = ""
Tags = ["Development"]
date = "2011-08-31T12:31:21-04:00"
title = "Cloud9 IDE"

+++

I've always wanted to like web based IDE's. However, there was one thing that always prevented it: they've always been terrible.

Until now that is. http://cloud9ide.com/ Cloud9 is epic. It's built on node.js and has support for coffeescript and sass syntax highlighting and real time error checking. I can't even find an desktop ide to do that right!

 It gets better though. It's 100% open source so you can install it on locally. I kinda used this as a general guide but didn't need most of it

 http://gratdevel.blogspot.com/2011/03/setting-up-cloud9-on-ubuntu-1010-32-bit.html

 I'm using node 4.9 because express doesn't support anything >= 5.x.x which is kinda shitty... You're supposed to be able to install cloud9 through npm but it didn't work for me so meh.

One thing that I ran into was compiling my scripts from the ide command line. It's very restrictive and doesn't allow you to freely execute commands. So I wrote a simple node.js script to compile my coffeescript and sass and it seems to do the job.

``` js
var exec = require('child_process').exec;

var run = function(cmd, max){
    var max = max != null ? max : 10000;
    var timeout;
    var p = exec(cmd, function (error, stdout, stderr){
        stdout != null && console.log(stdout);
        error != null && console.log(error);
        stderr != null && console.log(stderr);
    }).on('exit',function(code){
        console.log('done: ' + cmd);
        clearTimeout(timeout);
    });

    timeout = setTimeout(function(){
        console.log('killing: ' + cmd);
        p.kill();
    },max);
}
run("coffee -c *.coffee",1000);
run("sass --update --scss sass:css");
```

