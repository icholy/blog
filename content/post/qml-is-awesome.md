+++
Categories = ["Development", "QML"]
Description = ""
Tags = ["Development", "qml"]
date = "2011-09-30T12:20:44-04:00"
title = "QML is Awesome"

+++

QML is Nokia's recent addition to its well known Qt framework and comes part of the Qt Quick Suite 

The way I describe it to people is: 

> it's like html and css combined with the power of Qt in a extremely simple syntax.

{{% youtube TN4RrBIft6A %}}

### Why?

I have used Swing, WinForms, and GTK in the past and never really liked anything to do with GUI work. QML is the first time I'm actually enjoying designing user interfaces and this results in a better end result. It feels a lot more like web development except without browser specific issues.

### WebKit

Speaking of browsers, WebView is a QML element which embeds QWebKit in your application and can be accessed within the markup itself with javascript! This is how you would embed a WebView

``` qml
WebView { id: browser; url: "http://www.google.ca"; }
```

that's it ... you can access it in javascript through it's id property.

### Prediction

Assuming everything doesn't move to the web in the next few years, I think that QML is the future for GUI development.  It's simple, powerful and fun!
