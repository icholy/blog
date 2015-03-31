+++
Categories = ["Development", "vim"]
Description = ""
Tags = ["Development", "vim"]
date = "2012-12-07T11:29:54-04:00"
title = "Vim Marks"

+++

Marks are a feature that I’ve never really used enough. Hopefully writing about them will change that for the better.

### Make a basic, file local, mark called `a`

``` vim
ma
```

### Jump back to that mark

``` vim
'a
```

Now I try to be pragmatic. So use cases are what motivate me to learn new thing. I think that marks are a good replacement for a lot of the things I use visual line `V` mode for now.

**Editing**

Lets say a have some text

```
this
is
a
test
```

I want to remove lines 2-3.

Currently I’ll jump into visual line mode, select the lines and then `d` to delete them.

``` vim
Vjd
```

If I was going to do same thing with marks I’d set a mark on line 2 `ma`, go down a line `j`, go to the end of that line `$`, and then delete `,` go to the end of that line `$`, and then delete everything back to the mark `d'a`.

``` vim
maj$d'a
```

… not so great.

the best way would be `2dd` to delete the 2 lines. I guess there’s no point trying to use marks for manipulating entire lines. They’re more usefull when you want to do more complicated motions where you’re not trying to grab the entire line. Or maybe when the content you are targetting is very large and visual mode would obscure the view. I’m lazy and don’t feel like coming up with examples for those situations. So next to another use case.

**Jumping**

I think marks are more important in the case of navigation than in editing. Before I say anything else, you need to know that there are 2 different types of marks: Local `abcde....` and Global `ABCD....` Local marks are local to the file they are defined in. If a mark `b` exists in `file1` and then you define mark `b` in `file2`, they can both exist oblivious to eachother. Global marks are shared across files.

A good usage would be when your trying to debug some C function and you’re always jumping between the usage, declaration, and definitions. You could just set global marks for those points.

Undo is a very awesome thing. But most of the time it’s only used for reverting changes made. What about movement? You know those times when you accidentally hit some key and your cursor jumps to a completely different part of the page? `''` is your friend. It’s a special mark that denotes the last place you jumped from. It will keep jumping back and forth between the last 2 locations you were.

But say you did something really retarded and need to go back 3 jumps? In that case you need to bust out `CTRL-O` and his buddy `CTRL-I`. These will navigate forward and backward through the jump history.

`CTRL-O` and `CTRL-I` are the undo and redo when it comes to movement.

**Listing**

listing doesn’t really make sense as a heading when the other two are taken into account, but w.e. The way you list all the marks (global and local) is with the `:marks` command.

**Last Mod**

One last thing that you want to do is jump back to the last place you edited something. That’s what the `.` mark is for. `.'` will take you back to your last edit location.

**Line or Char?**

Ok so I left out a small tidbit of information, but it’s not that complicated. When you access a mark using `'` then you will jump to the beginning of the line where the mark was defined. If you want to jump to the exact character where the mark was created, then you need to use `` ` ``.
