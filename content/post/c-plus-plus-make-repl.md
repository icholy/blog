+++
Categories = ["Development", "C++"]
Description = ""
Tags = ["Development", "cpp"]
date = "2012-12-31T11:26:44-04:00"
title = "C++: Make Repl"

+++

One of the things I really like about dynamic languages like javascript & python is the repl. After you’ve gotten used to that type of exploratory programming, it’s hard to go back to the edit/compile/run cycle.

Luckily that has finally changed with [cling](http://root.cern.ch/drupal/content/cling). It’s an interactive C++ environment that behaves pretty much like a repl. In my recent projects I’ve been adding a new make rule: repl which lets me interactively play with the code I’m working on and it has drastically improved my productivity.

Here’s how I set it up. Compiling cling is the first step. Below are how I did it on OSX.

``` sh
brew install gcc
brew install make


# Check out the sources:

mkdir src
cd src
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
svn co http://root.cern.ch/svn/root/trunk/cint/cling cling
cd ..

# Apply some patches

cat tools/cling/patches/* | patch -p0

# Configure, build and install them

cd ..
mkdir build
cd build
../llvm/configure --enable-targets=host
make
make install
```
Next there’s an `init_repl.cpp` file I keep in the root of my project. It’s responsible for pulling in all the required headers and doing some initial setup. For the setup, I use C++’s version of a static block.

``` cpp
#include <my_project.h>
#include <iostream>
#include <string>

struct ReplInit {
  ReplInit () {
    std::cout << "initializing some stuff" << std::endl;
  }
};

static ReplInit repl_init;
```

Next the make rule.

``` make
repl:
  cling -std=c++11 -linit_repl.cpp -llibmy_project.so -I./include -I./src -I./lib
```

After that you should just be able to run `make repl` and you’ll be dropped into a shell where you can dynamically explore you project. I’ve only been using it for a little while and I’m hooked. I look forward to the day where every project supports `make && make repl`.
