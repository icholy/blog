+++
Categories = ["Development", "JavaScript"]
Description = ""
Tags = ["Development", "javascript", "codegen"]
date = "2012-10-18T12:02:06-04:00"
title = "SWAPM: Code generation made easy."

+++

I finally got around to reading the Pragmatic Programmer book. One thing that really interested me was the section on Code Generation. So in a recent C++ project I was interfacing with postgres and there was a LOT of code repetition. The sql query, class members, getters/setters, response parsing logic. They all contained the same information. Perfect I thought, here was the ideal chance to give code generation a shot. My first incarnation was a very ugly perl script (aren't they all .. ?)  which used mustache as the templating engine. It worked, But I had to copy and paste the generated code into my source every time it changed which was a pain.

Here's what I really wanted:

* have the generated code automatically be inserted into my source.
* have an extemely simple templating language
* solution for situations where simple templating wasn't enough (computed properties).
* separate my data from the templates
* VERY easy to use.
* VERY easy to integrate into existing projects.

I spent a decent amount of time googling but all I found was

* cheetah: http://www.cheetahtemplate.org/
* cog: http://nedbatchelder.com/code/cog/

I didn't like them though. Cheetah is too complicated and cog is too limited.

So I set off to make my own. https://github.com/icholy/swapm . I am using it in my projects with a very high level of satisfaction. I wrote it in javascript because node makes it portable, npm makes distribution painless, and I wanted support for having computed properties in my data.

Regarding the name, I'm not very creative and originally called it swap but that name was already taken on npm. So I renamed it to swapm pronounced "Swap-Em".

** Note: ** It's still very much a work in progress at the time of writing so use at your own risk of it eating your code. Github issues are always appreciated.



