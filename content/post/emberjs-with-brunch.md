+++
Categories = ["Development", "JavaScript"]
Description = ""
Tags = ["Development", "javascript", "emberjs"]
date = "2012-06-07T12:04:56-04:00"
title = "Ember.js with Brunch"

+++

I've recently discovered the brilliant [Ember.js](http://emberjs.com/) library and the first major issue I ran into was how to organize/modularize this thing!? At first I just opted into [RequireJs](http://requirejs.org/) because that's what I know but I started hitting walls fast. I decided to try out the [Brunch](http://brunch.io/) build system since I had heard good things about it before and this was a great opportunity to learn how to use it. Brunch uses skeletons which are essentially project templates to get rid of the boilerplate. Google search "ember brunch" and I found [charlesjolley/ember-brunch](https://github.com/charlesjolley/ember-brunch) perfect!

Unfortunately it hasn't been kept up to date... [Relevant Issue](https://github.com/charlesjolley/ember-brunch/issues/1)

If Charles wasn't going to update it even after Paul (Brunch's author) asked him to then it definitely wasn't going to happen. So I was left with only one option, write my own [icholy/ember-brunch](https://github.com/icholy/ember-brunch)  
Paul was kind enough to include it on the brunch.io homepage. Once ember 1.0 is finally released I'll restructure the skeleton to use the new Ember.Router and Ember.States.

It Includes:

* Template compiling
* CoffeeScript version (coffee branch)
* Twitter Bootstrap (not a big deal but nice)

