+++
Categories = ["Development", "JavaScript"]
Description = ""
Tags = ["Development", "javascript", "coffeescript"]
date = "2011-08-07T12:37:05-04:00"
title = "CoffeeScript"

+++

I just spent the last 5 hours learning CoffeeScript and I feel like I have pretty much everything down. My brain is kinda dead right now, but at the same time I'm pretty excited to actually try it in a real project. In case you don't know CoffeeScript is a python-esque language which 'compiles' into javascript. classes, list comprehension  inheritance, ranges, semantic code etc.... dream come true. http://jashkenas.github.com/coffee-script/

One thing I was worried about was being able to use 3rd party libraries with it. It's actually not different at all... Once you figure it all out, you realize that it's still the exact same js you're working with and you can do just as much. It's just a lot less shitty. Yes, the learning curve is balls, but it's definitely worth it (i hope).

**CoffeeScript:**

``` coffeescript
cubes = (num * num for num in list)
```

**Output**

``` js
var cubes, num;
cubes = (function() {
  var _i, _len, _results;
  _results = [];
  for (_i = 0, _len = list.length; _i < _len; _i++) {
    num = list[_i];
    _results.push(num * num);
  }
  return _results;
})();
```

