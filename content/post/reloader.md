+++
Categories = ["Development", "JavaScript"]
Description = ""
Tags = ["Development", "javascript"]
date = "2011-07-20T12:40:37-04:00"
title = "Reloader - multi browser live web preview"

+++

I recently started developing on linux and unfortunately stylizer 5 does not support linux. So I'm back to using kate. However, one thing that I really missed right away was the instant preview feature. Having to go and refresh multiple browsers every time you change a line of code blows. I searched around for a bit and found a few tools but none of them were any good. I needed something that would work in multiple browsers at the same time and I couldn't find anything to my liking so I wrote my own. 

Reloader: https://github.com/icholy/reloader ( check wiki for basic tutorial )

Not the most inspired name, but it was free on google code so why not?

**How It Works**

Basically it's a small http server written in python. The javascript in the browser polls the server via jsonp and when a file is modified in the target directory, either a "refresh-css" or "refresh-page" command is sent.

**Multi Browser**

The server uses cookies to distinguish between multiple browsers. This way it doesn't send the same update command to the same browser twice.

**Windows Support**

I'm using the pyinotify python library to monitor the directory but it's not cross platform. I used twisted-web to create the server so that's completely portable. So i'm currently on the lookout for a pyinotify replacement.
