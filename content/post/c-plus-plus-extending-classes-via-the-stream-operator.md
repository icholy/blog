+++
Categories = ["Development", "C++"]
Description = ""
Tags = ["Development", "cpp"]
date = "2012-12-03T11:49:42-04:00"
title = "C++ Extending Classes via the Stream Operator"

+++

### Vision

Looking for a way to create a class which behaved like one of the `std::ostream` classes.

``` cpp
MyClass obj;

obj << "foo" << 123 << some_string.c_str();
```

### Problem

Implementing all those `operator<<` overloads would be redundant because something like `std::stringstream` already does it. However inheriting from `std::stringstream` is more complicated than it should be.

``` cpp
struct MyClass : public std::stringstream {
    /* not that simple ... */
};
```

### Solution

You can use a simple template to achive the desired effect.

``` cpp
struct MyClass {

    std::stringstream m_ss;

    template <class T>
    MyClass & operator<< (T const& rhs) {
        m_ss << rhs;
        return *this;
    }
};
```

This comes with the benefit being able to ‘hook’ into each invocation.

