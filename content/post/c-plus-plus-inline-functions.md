+++
Categories = ["Development", "C++"]
Description = ""
Tags = ["Development", "cpp"]
date = "2012-12-31T11:21:15-04:00"
title = "C++: Inline Functions"

+++

Even though overuse of getter and setter functions can be frowned upon, they can help a lot if you’re looking to provide a intuitive api. However the overhead the additional function call introduces is undesirable. Thankfully, there’s the `inline` keyword. It tells the compiler to replace each invocation of the function with the body of the function.

``` cpp
struct Foo {
  int m_number = 123;

  inline int number () {
    return m_number;
  }
};

int main () {
  Foo foo;

  // used like a regular function
  std::cout << foo.number() << std::endl;

  // compiled to almost identical assembly as this
  std::cout << foo.m_number << std::endl;

  return 0;
}
```

However the `inline` keyword isn’t a guarantee that the compiler will do this. It’s more of a hint to the compiler. So keep in mind that the compiler is free to ignore the fact that a function is declared `inline` and it can inline functions that haven’t been delcared as such. But in examples similar to the one above, you can assume it will behave as expected.

Another important piece of information is that the function definition needs to be available in every translation unit.

``` cpp
// foo.h
inline int foo ();
```

``` cpp
// foo.cpp
#include "foo.h"

int foo () {
  return 123;
}
```

If I try to use the `foo` function by including `foo.h` I’d get a warning telling me that the `foo` is not defined. This won’t prevent compilation, but the function will not get inlined. The compiler needs access to the function body to replace it with the call site. There’s a simple solution though. Just put the function definition in the header.

``` cpp
// foo.h
inline int foo () {
  return 123;
}
```

One finall note. Using `inline` too much can not only make your binary much bigger, but it can also slow it down due to the way things are cached during execution. So only use them on very small functions (1-3 lines) and you should be good.
