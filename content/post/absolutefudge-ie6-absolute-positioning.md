+++
Categories = ["Development", "CSS"]
Description = ""
Tags = ["Development", "css"]
date = "2011-07-14T12:48:23-04:00"
title = "absoluteFudge - ie6 absolute positioning"

+++

I don't know about you, but here is a snippet of css that I love.

``` css
div#selector {
   position: absolute;
   left: 10px;
   right: 10px;
   top: 10px;
   bottom: 10px;
}
```

assuming that the parent element has either relative or absolute positioning, the child div will fit inside with a 10px margin. This is a very powerful technique for creating liquid css layouts.

**Problem**

The problem is, that ie doesn't support giving values to all sides (top,bottom,left,right) so you were forced to have a separate stylesheet for ie with a static layout.

**Solution**

Say hello to absoluteFudge http://www.nixsoft.co.uk/resources/absolutefudge.js
backup: http://pastebin.com/X4568XMR
It's sweet, just run it in ie6 and all absolute positioning problems are fixed.

I use jquery to detect the browser

``` js
$(document).ready(function(){
    if($.browser.msie && $.browser.version=="6.0"){
        AbsoluteFudge.apply($('body')[0], true, true);
    }
}
```

that's it, problem solved.
