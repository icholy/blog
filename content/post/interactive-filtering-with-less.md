+++
Categories = ["Development", "linux"]
Description = ""
Tags = ["Development", "linux"]
date = "2014-03-31T12:56:53-04:00"
title = "interactive filtering with less"

+++

I discovered a cool little feature in [less](http://linux.die.net/man/1/less) (not less.css) today. You can interactively filter the data.

``` man
&pattern

	Display only lines which match the pattern; lines which do not match the pattern are not displayed. If pattern is empty (if you type & immediately followed by ENTER), any filtering is turned off, and all lines are displayed. While filtering is in effect, an ampersand is displayed at the beginning of the prompt, as a reminder that some lines in the file may be hidden.

	Certain characters are special as in the / command:
```

**Activate:** `&pattern` hit enter  
**Disable:** `&` hit enter

Demo:

![demo](/images/less-filtering.gif)

