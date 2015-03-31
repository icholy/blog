+++
Categories = ["Development", "CSS"]
Description = ""
Tags = ["Development", "css"]
date = "2012-10-27T12:10:52-04:00"
title = "CSS Compass Gradient Generator"

+++

This is a css gradient generator that i've been using for a while:

* http://www.colorzilla.com/gradient-editor/

**CSS Output**

``` css
background: #1e5799; /* Old browsers */
background: -moz-linear-gradient(top, #1e5799 0%, #2989d8 50%, #207cca 51%, #7db9e8 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#1e5799), color-stop(50%,#2989d8), color-stop(51%,#207cca), color-stop(100%,#7db9e8)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top, #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* IE10+ */
background: linear-gradient(top, #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#1e5799', endColorstr='#7db9e8',GradientType=0 ); /* IE6-9 */
```

However I just noticed the **switch to scss** option!

**SCSS Ouput**

``` scss
@include filter-gradient(#1e5799, #7db9e8, horizontal);
$experimental-support-for-svg: true;
@include background-image(
    linear-gradient(left, #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%));
```

This makes implementing complex cross-browser css gradients painless.

